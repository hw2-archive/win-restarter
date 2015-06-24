{
 *
 * Copyright (C) 2005-2009 UDW-SOFTWARE <http://udw.altervista.org/>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
}

Unit Engine;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,  Wininet, ShellAPI,Controls, Forms, TlHelp32 , Dialogs, Restart;

const
  MaxThreads        =  1;


 Type thread = class(TThread)
  protected
     // Protected declarations
   procedure      Execute; override;
   procedure   Handlelabelstatus;
  public
   constructor Create(susp:boolean);
  end;

 
 Type
  TEnumData = Record
    hW: HWND;
    pID: DWORD;
  End;


procedure Init(var Rec:Array of RecData; I:integer);
procedure ThreadCreate(susp:boolean);
procedure delrow(I:integer);
procedure ResetUptime(var Rec:Array of RecData; I:integer);
Function EnumProc( hw: HWND; Var data: TEnumData ): Bool; stdcall;
Function WindowFromProcessID( pID: DWORD ): HWND;
function GetInetFile(const fileURL, FileName: String):boolean;
function CheckIntFile(const fileURL: String):boolean;
function VersioneApplicazione(const PathApplicazione: string): string;
function CreateIniFile(dir:string):boolean;
function CheckFile(path:string):boolean;
function ExecuteFile(const FileName,Params,DefaultDir: String; ShowCmd: Integer): THandle;
function CreateProcessSimple(FileName: string;var MPInfo: TProcessInformation ): string;
function IsApplicationRunning(applicationName: String): boolean;
function FNameNoExt(const FileName: String): String;

var
    ThreadCounter:integer;
    updatedcheck,crescente:boolean;
    Reg: array of RecData;

implementation
//#############################################################################
//
// FUNZIONI DEL THREAD         (SHARED)
//
//#############################################################################


procedure ThreadCreate(susp:boolean);
 var dwThreads:     Integer;
begin
   // Increase the thread counter
   try
   InterlockedIncrement(ThreadCounter)
   finally
    dwThreads:=InterlockedDecrement(ThreadCounter);
   end;

   if (dwThreads < MaxThreads) then
    Thread.Create(susp);
     // Perform inherited (don't suspend)
end;


procedure Thread.Execute;
begin
  Form1.CheckVersion;
  Synchronize(self,handlelabelstatus);
end;

procedure Thread.Handlelabelstatus;
var state:string;
begin

if updatedcheck then
  begin
    state:='Out of date'#13#10'   [CLICK HERE]';
    Form1.Versione.Font.Color:=clRed;
  end
  else
  begin
    state:=' [Updated] ';
    Form1.Versione.Font.Color:=clGreen;
  end;

  form1.Versione.Caption:='Version: ' + form1.Version +' '+state;
end;


constructor Thread.Create(susp:boolean);
begin
    inherited Create(susp);
    // Set thread props
    InterlockedIncrement(ThreadCounter);
    FreeOnTerminate:=True;
    Priority:=tpLower;
end;


//  #####################################
//
// FUNZIONI DI SUPPORTO
//
//  #####################################


procedure delrow(I:integer);
begin

 if (I=0) or (Length(Reg)=0) then Exit;   //antihack

 Form1.Timers.RowHeights[I]:=0; //effetto delete
 Reg[I-1].deleted:=true;
 Reg[I-1].blocca:=true;
 Form1.HideProc(I,true);

 dec(Form1.ProcCount,1);

 Form1.SaveBtn.Enabled:=true;
 Form1.RestoreBtn.Enabled:=true;
 Form1.CheckEnabling;

 Form1.ChangeStopBtn(I);
 Form1.ChangeHideBtn(I);

end;




procedure Init(var Rec:Array of RecData; I:integer);
begin
  // Rec[I]:=malloc(sizeof(RecData));
  Rec[I].deleted:=false;
  Rec[I].added:=false;
  Rec[I].restarts:=-1;
  ResetUptime(Rec,I);
  Initialize(AnsiString(Rec[I].APPName) );
  Initialize(AnsiString(Rec[I].APPPath) );
end;




Function EnumProc( hw: HWND; Var data: TEnumData ): Bool; stdcall;
  Var
    pID: DWORD;
  Begin
    Result := True;
    If (GetWindowLong(hw, GWL_HWNDPARENT) = 0) and
       ((GetWindowLong(hw, GWL_EXSTYLE) and WS_EX_APPWINDOW) <> 0)
    Then Begin
      GetWindowThreadProcessID( hw, @pID );
      If pID = data.pID Then Begin
        data.hW := hW;
        Result := False;
      End; { If }
    End; { If }
  End; { EnumProc }

Function WindowFromProcessID( pID: DWORD ): HWND;
  Var
    data: TEnumData;
Begin
    data.pID := pID;
    data.hW := 0;
    EnumWindows( @EnumProc, longint(@data) );
    Result := data.hW;
End;
 
function GetInetFile(const fileURL, FileName: String):boolean;
const
  BufferSize=1024;
var
  hSession, hURL:HInternet;
  Buffer: array[1..BufferSize] of Byte;
  BufferLen: DWORD;
  sAppName: string;
  f:File;
begin
  result :=false;
  sAppName := ExtractFileName(Application.ExeName);
  hSession := InternetOpen(PChar(sAppName), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  try
    hURL := InternetOpenURL(hSession, PChar(fileURL), nil, 0, 0, 0);
    try
      AssignFile(f, FileName);
      Rewrite(f, 1);
    repeat
      InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen);
      BlockWrite(f, Buffer, BufferLen)
    until BufferLen = 0;
      CloseFile(f);
      result := true;
    finally
    end
  finally
  end;
  InternetCloseHandle(hURL);
  InternetCloseHandle(hSession);
end;



function CheckIntFile(const fileURL: String):boolean;
const
  BufferSize=1024;
var
  hSession, hURL:HInternet;
  sAppName: string;
begin
  hURL:=nil;
  sAppName := ExtractFileName(Application.ExeName);
  hSession := InternetOpen(PChar(sAppName), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if hSession<>nil then
  begin
    hURL:= InternetOpenURL(hSession, PChar(fileURL), nil, 0, 0, 0);
    if hURL<>nil then result := true
    else result:=false;
    InternetCloseHandle(hURL);
  end;
InternetCloseHandle(hSession);
end;



function VersioneApplicazione(const PathApplicazione: string): string;
var
    DimVariabile1: dword;
    DimVariabile2: dword;
    Puntatore1: Pointer;
    Puntatore2: Pointer;
begin
    Result := '';
    DimVariabile1 := GetFileVersionInfoSize(PChar(PathApplicazione), DimVariabile2);
    if DimVariabile1 > 0 then
    begin
        GetMem(Puntatore1, DimVariabile1);
        try
        GetFileVersionInfo(PChar(PathApplicazione), 0, DimVariabile1, Puntatore1); // ottengo i dati della versione
        VerQueryValue(Puntatore1, '\', Puntatore2, DimVariabile2);
        with TVSFixedFileInfo(Puntatore2^) do
        Result := Result + // Costruisco la stringa di versione
        IntToStr(HiWord(dwFileVersionMS)) + '.' +
        IntToStr(LoWord(dwFileVersionMS)) + '.' +
        IntToStr(HiWord(dwFileVersionLS)) + '.' +
        IntToStr(LoWord(dwFileVersionLS));
        finally
        FreeMem(Puntatore1);
        end;
    end;
end;


procedure ResetUptime(var Rec:Array of RecData; I:integer);
begin
       Rec[I].tempo1:=Now;
       Rec[I].days:=-1;
       Rec[I].DiffDays:=0;
end;

function FNameNoExt(const FileName: String): String;
begin
  Result := ExtractFileName(FileName);
  Result := Copy(Result, 1, Length(FileName) - Length(ExtractFileExt(Result)));
end;




function IsApplicationRunning(applicationName: String): boolean;
var
handler: THandle;
data: TProcessEntry32;
bRet: boolean;

function GetName: string;
  var i:byte;
  begin
   Result := '';
   i := 0;
   while data.szExeFile[i] <> '' do
    begin
     Result := Result + data.szExeFile[i];
     Inc(i);
    end;
end;

begin
 bRet:= false;
 try
  handler := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
  data.dwSize := SizeOf(TPROCESSENTRY32);
  if Process32First(handler, data) then
  begin
    while Process32Next(handler, data) do
    begin
     if STRING(STRUPPER(PANSICHAR(GetName()))) = STRING(STRUPPER(PANSICHAR(applicationName))) then
      bRet:= true
    end;
  end;
  except
  end;
 result:= bRet;
end;





function CreateProcessSimple(FileName: string;var MPInfo: TProcessInformation ): string;
var
  SInfo: TStartupInfo;
begin
  FillMemory(@SInfo, SizeOf(SInfo), 0);
  SInfo.CB:=SizeOf(SInfo);
  //aggiunta filepath per poter avviare applicazioni da altre cartelle (bisogna inserire un percorso completo!)
  CreateProcess(nil, PChar(FileName), nil, nil, false, NORMAL_PRIORITY_CLASS, nil, PChar(ExtractFilePath(Filename)), SInfo, MPInfo);
  //showmessage(inttostr(MPInfo.dwProcessId));
  CloseHandle(MPInfo.hProcess);
  CloseHandle(MPInfo.hThread);
end;




function ExecuteFile(const FileName,Params,DefaultDir: String; ShowCmd: Integer): THandle;
begin
  Result:=ShellExecute(Application.Handle,nil,PChar(FileName),PChar(Params),PChar(DefaultDir),ShowCmd);
end;

function CheckFile(path:string):boolean;
begin
   if FileExists(path) then // controlla prima che il file esista
    CheckFile:=true
   else
    begin
     CheckFile:=false;
     showmessage(path+' : This file doesn''t exist');
    end;
end;




function CreateIniFile(dir:string):boolean;
begin
    if not DirectoryExists(dir) then
      CreateDirectory(PAnsiChar(dir),nil);

    Form1.IniWrite;
end;


end.









