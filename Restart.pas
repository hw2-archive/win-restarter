{
 *
 * Copyright (C) 2005-2009 UDW-SOFTWARE <http://udw.altervista.com/>
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


unit Restart;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Wininet, TlHelp32 ,IniFiles, ShellAPI,
  Buttons, Grids, Menus, Spec, ComCtrls, OleCtrls, SHDocVw, ActnList,
  ToolWin, ActnMan, ActnCtrls, ActnMenus, XPStyleActnCtrls;


const
   WM_MYICON = WM_USER + 1;

   GrdID       = 0;
   GrdName     = 1;
   GrdDays     = 2;
   GrdUptime   = 3;
   GrdRestarts = 4;
   GrdPath     = 5;
   GrdErrWin   = 6;



 type
    RecData = record
     tempo1: TDateTime;
     days,restarts,DiffDays: integer;
     blocca,nascosto,deleted,added: boolean;
     APPPath,APPName,ErrWindowName: string;
     APPInfo: TProcessInformation;
    end;


   Type
    TForm1 = class(TForm)
    Timer1: TTimer;
    Timers: TStringGrid;
    SecCount: TComboBox;
    Timer2: TTimer;
    SaveBtn: TBitBtn;
    RestoreBtn: TBitBtn;
    WebBrowser: TWebBrowser;
    ProcName: TGroupBox;
    Timer: TLabel;
    giorni: TLabel;
    STOP: TButton;
    GroupBox1: TGroupBox;
    Clean: TButton;
    uptime: TButton;
    Del: TBitBtn;
    Add: TBitBtn;
    Edit: TButton;
    Versione: TLabel;
    StopAll: TButton;
    Timer3: TTimer;
    PopupMenu1: TPopupMenu;
    stopallmenu: TMenuItem;
    AddMenu: TMenuItem;
    ExitMenu: TMenuItem;
    SaveMenu: TMenuItem;
    Tray: TBitBtn;
    ActionManager1: TActionManager;
    ActionMainMenuBar1: TActionMainMenuBar;
    BugSection: TAction;
    About: TAction;
    HideAll: TButton;
    Hide: TButton;
    hideallmenu: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure STOPClick(Sender: TObject);
    procedure StopAllClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure CleanClick(Sender: TObject);
    procedure licenseClick(Sender: TObject);
    procedure uptimeClick(Sender: TObject);
    procedure AddClick(Sender: TObject);
    procedure TimersSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure SaveBtnClick(Sender: TObject);
    procedure DelClick(Sender: TObject);
    procedure RestoreBtnClick(Sender: TObject);
    procedure TimersClick(Sender: TObject);
    procedure EditClick(Sender: TObject);
    procedure TimersRowMoved(Sender: TObject; FromIndex, ToIndex: Integer);
    procedure VersioneClick(Sender: TObject);
    procedure ErrWindowChange(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ExitMenuClick(Sender: TObject);
    procedure TimersMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrayClick(Sender: TObject);
    procedure BugSectionExecute(Sender: TObject);
    procedure AboutExecute(Sender: TObject);
    procedure HideClick(Sender: TObject);
    procedure HideAllClick(Sender: TObject);
  private
    { Private declarations }
    bloccatutti:boolean;       // bloccarealm:boolean;
    RstPath,RstName,RstNameNoExt:string;
    LauncherIni: TIniFile;

   FIconData: TNotifyIconData;
   procedure Sortgrid(Grid : TStringGrid; SortCol:integer);
   procedure WMMYIcon(var Message: TMessage); message WM_MYICON;
   procedure AppMinimize(Sender: TObject);
   procedure AddIcon;

  public
    { Public declarations }
   APPNum,ProcCount: integer;
   Tempo2 : array of TDateTime;
   Version,InfoFile,NavUrl,
   RstFolder:string;
   procedure CheckEnabling;
   procedure HandleName(Arg:string;row:integer);
   procedure CheckVersion;
   procedure EnableRestarter(switch:boolean);
   function  CreaGriglia(First:boolean): Boolean;
   procedure ChangeStopBtn(Row:integer);
   procedure ChangeHideBtn(Row:integer);
   procedure HideProc(row:integer;forceshow:boolean);
   procedure StopProc(Row:integer);
   procedure HideAllProc(forceshow:boolean);
   procedure IniWrite;
  end;

  var
    Form1: TForm1;

 // DaHandle : HWND;

implementation

uses Engine;

{$R *.dfm}
{$R winxp.res}

// ============================================  //
//
//                  FUNZIONI DI SUPPORTO
//
// ============================================ //


procedure TForm1.Sortgrid(Grid : TStringGrid; SortCol:integer);
{A simple exchange sort of grid rows}
var
   i,j : integer;
   temp:tstringlist;
   temp3: recdata;
begin

  temp:=tstringlist.create;
  with Timers do
  for i := FixedRows to RowCount - 2 do  {because last row has no next row}
  for j:= i+1 to rowcount-1 do {from next row to end}
  if not Reg[j-1].deleted then
  if ( (crescente) AND (AnsiCompareText(Cells[SortCol, i], Cells[SortCol,j]) > 0 ) )
     OR ( not crescente AND (AnsiCompareText(Cells[SortCol, i], Cells[SortCol,j]) < 0 ))
  then
  begin
      temp.assign(rows[j]);
      rows[j].assign(rows[i]);
      rows[i].assign(temp);
      // reg data updating
      temp3:=reg[j-1];
      reg[j-1]:=reg[i-1];
      reg[i-1]:=temp3;
  end;
  temp.free;
  crescente:=not crescente;
end;




procedure TForm1.HideAllProc(forceshow:boolean);
var i:integer;
begin
 for I:=0 to APPNum-1 do
  HideProc(I+1,forceshow);
end;


procedure TForm1.AddIcon;
begin
    with FIconData do
    begin
      cbSize := SizeOf(FIconData);
      Wnd := Self.Handle;
      uID := $DEDB;
      uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
      hIcon := Forms.Application.Icon.Handle;
      uCallbackMessage := WM_MYICON;
      StrCopy(szTip, PChar(Caption));
    end;
    Shell_NotifyIcon(NIM_Add, @FIconData);
end;

procedure TForm1.WMMYIcon(var Message: TMessage);
var
  p : TPoint;
begin
  case Message.lParam of
    WM_LBUTTONDOWN:
    begin
    if visible then
    begin
        //Application.OnMinimize:=AppMinimize;
        //Application.OnRestore:=AppMinimize;
        Application.Minimize;
        AppMinimize(@Self);
        Visible:=false;
     end else
     begin
        application.Restore;
        Visible:=true;
        self.SelectFirst;
        BringToFront;
     end;
    end;
    WM_RBUTTONDOWN:
    begin
       SetForegroundWindow(Handle);
       GetCursorPos(p);
       PopUpMenu1.Popup(p.x, p.y);
       PostMessage(Handle, WM_NULL, 0, 0);
    end;
  end;

end;



procedure  TForm1.AppMinimize(Sender: TObject);
begin
 ShowWindow(Application.Handle, SW_HIDE);
end;



{
function malloc(size: cardinal): pointer;
begin
  GetMem(result,size);
end;
 }

procedure TForm1.EnableRestarter(switch:boolean);
begin

     Timer1.Enabled:=switch; // abilita il timer solo se ci sono processi
     Timer2.Enabled:=switch;

     STOP.Enabled:=switch;
     StopAll.Enabled:=switch;
     Clean.Enabled:=switch;
     uptime.Enabled:=switch;
     edit.Enabled:=switch;
     del.Enabled:=switch;
     Hide.Enabled:=switch;
     HideAll.Enabled:=switch;
end;

procedure TForm1.CheckEnabling;
begin
  if ProcCount>=1 then
  begin
     timers.FixedRows:=1;
     EnableRestarter(true);
  end
  else
     EnableRestarter(false);
end;

procedure TForm1.HandleName(Arg:string;row:integer);
begin
if Arg='' then
 begin
   Reg[row-1].APPName:='APP '+inttostr(row);
   Timers.Cells[grdname,row]:=Reg[row-1].APPName;
 end
   else
 begin
   Reg[row-1].APPName:=arg;
   Timers.Cells[grdname,row]:=arg;
 end;

end;


procedure Tform1.ChangeHideBtn(Row:integer);
begin


 if (Hide.Enabled) and (row>=1) then
 if Reg[row-1].nascosto then
   hide.Caption:='SHOW'
 else
   hide.Caption:='HIDE';

end;


procedure TForm1.StopProc(Row:integer);
var I:integer;
begin

if (row>=1) and (CheckFile(Reg[row-1].APPPath)) then // controlla prima che il file esista
if NOT Reg[row-1].blocca then
  begin
    Reg[row-1].blocca:=true;
    i:=0;
    while (not bloccatutti) and (i<length(reg)) do
      if Reg[i].blocca then
      begin
       if i=length(reg)-1 then bloccatutti:=true
       else inc(i);
      end
      else i:=length(reg);

    if bloccatutti then StopAll.Caption:='START ALL';
  end
 else
   begin
    Reg[row-1].blocca:=false;
    StopAll.Caption:='STOP ALL';
    bloccatutti:=false;
   end;

 stopallmenu.Caption:=StopAll.Caption;
 ChangeStopBtn(row);
end;



procedure TForm1.ChangeStopBtn(Row:integer);
begin
 if (STOP.Enabled) and (row>=1) then
 if Reg[row-1].blocca then
   stop.Caption:='START'
 else
   stop.Caption:='STOP';

 ProcName.Caption:='['+Timers.Cells[GrdId,row]+'] '+Timers.Cells[GrdName,Row];
end;

procedure TForm1.IniWrite;
 var TempIni: TIniFile;
     TempFile: File;
     i: integer;
begin

   AssignFile(TempFile,RstPath+RstFolder+RstNameNoExt+'.ini');

   Rewrite(TempFile);

   TempIni:=TIniFile.Create(RstPath+RstFolder+RstNameNoExt+'.ini');

   //ErrWindowName:=ErrWindow.Text;
  // TempIni.WriteString('Options','ErrorWindowName', ErrWindowName);

   for I:=0 to Length(Reg)-1 do
   if (Length(Reg)<>0) and (Reg[I].deleted<>true) then
    begin
     TempIni.WriteString('APP'+inttostr(I+1),'path',Reg[I].APPPath);
     TempIni.WriteString('APP'+inttostr(I+1),'name',Reg[I].APPName);
     TempIni.WriteBool('APP'+inttostr(I+1),'disable',Reg[I].blocca);
     TempIni.WriteString('APP'+inttostr(I+1),'ErrWindowName',Reg[I].ErrWindowName);
    end;

   TempIni.Free;

end;


function TForm1.CreaGriglia(First:boolean): Boolean;
var I,count:integer;
    avviato:boolean;
    TempReg: array of RecData;
    Gname,temp:string;
begin

AppNum:=0;
ProcCount:=0;
count:=0;

timers.Cells[GrdName,0] := 'Name';
timers.Cells[GrdDays,0] := 'Days';
timers.Cells[GrdUptime,0] := 'Uptime';
timers.Cells[GrdRestarts,0] := 'Restarts';
timers.Cells[GrdPath,0] := 'Path';
timers.Cells[GrdID,0] := 'ID';
timers.Cells[GrdErrWin,0] := 'Error Window Name';

avviato:=false;

if FileExists(RstPath+RstFolder+RstNameNoExt+'.ini') then
  begin

  LauncherIni:=TIniFile.Create(RstPath+RstFolder+RstNameNoExt+'.ini');


 // ErrWindow.Text:=ErrWindowName;

  LauncherIni.ReadSections(SecCount.Items);  //utilizzo temporaneo del componente per
  //SecCount.Items.Delete(0);  // cancella la sezione options
  // sec count è necessario per impostare le row

  timers.RowCount:=SecCount.Items.count+1;  // tante colonne quante contate + una fixed

  AppNum:=SecCount.Items.count;
  ProcCount:=AppNum;

  if Length(Reg)>0 then
  begin

   SetLength(TempReg,ProcCount);

   for I:=0 to Length(Reg)-1 do
   begin

    if Reg[I].deleted<>true then
    begin
     init(TempReg,count);
     TempReg[count]:=Reg[I];

     TempReg[count].added:=false;
     if TempReg[count].APPName='' then
       TempReg[count].APPName:='APP '+inttostr(I+1);

     inc(count);  // incrementa alla fine
    end;
   end;

   SetLength(Reg,0);
   SetLength(Reg,Length(TempReg));
   SetLength(Tempo2,0);
   SetLength(Tempo2,Length(TempReg));

   for I:=0 to Length(TempReg)-1 do
   begin
    Reg[I]:=TempReg[I];
    timers.Rows[I+1].Clear;
    timers.RowHeights[I+1]:=Timers.DefaultRowHeight;
    HandleName(Reg[I].APPName,I+1);
    timers.Cells[GrdPath,I+1] := Reg[I].APPPath;
    Timers.Cells[GrdId,I+1]:='APP'+inttostr(I+1);
    timers.Cells[GrdDays,I+1] := inttostr(Reg[I].DiffDays);
    timers.Cells[GrdRestarts,I+1] := inttostr(Reg[I].restarts);
    timers.Cells[GrdErrWin,I+1] :=  Reg[I].ErrWindowName;
   end;
  end
  else
  begin

  SetLength(Reg,AppNum);
  SetLength(Tempo2,AppNum);

  if AppNum>=1 then
  begin

    // L'array dinamico parte dal valore 0
    for I:=0 to AppNum-1 do
     begin
       Timers.Rows[I+1].Clear;
       Init(Reg,I);
     end;

     Timers.Cols[GrdID].AddStrings(SecCount.Items);


     for I:=0 to AppNum-1 do
      begin
        Gname:=Timers.Cells[GrdID,I+1];
        Reg[I].APPName:=LauncherIni.ReadString(Gname ,'name',''); //default vuoto che verrà gestito in seguito
        Reg[I].APPPath:=LauncherIni.ReadString(Gname,'path','NOT DEFINED');
        Reg[I].blocca:=LauncherIni.ReadBool(Gname,'disable',false);
        Reg[I].ErrWindowName:=LauncherIni.ReadString(Gname,'ErrWindowName','');
        // anti loop
        if Reg[I].APPPath=ExtractFileName(application.ExeName) then
         begin
           Reg[I].APPName:='ERROR';
           Reg[I].APPPath:='NOT DEFINED';
         end;

        HandleName(Reg[I].APPName,I+1);

        if CheckFile(Reg[I].APPPath) then
        begin
         if IsApplicationRunning(extractfilename(Reg[I].APPPath)) then
           avviato:=true;
         Reg[I].blocca:=false;
        end
        else
         Reg[I].blocca:=true;

        reg[I].nascosto:=false;

        Timers.cols[GrdName].Add(Reg[I].APPName);
        timers.cols[GrdPath].Add(Reg[I].APPPath);
        timers.cols[GrdErrWin].Add(Reg[I].ErrWindowName);
      end;

   end;

  end;


   LauncherIni.Free;

  end
  else
  begin
    CreateIniFile(RstPath+RstFolder);
    SetLength(Reg,0);
    MessageDlg(RstPath+RstFolder+RstNameNoExt+'.ini'+' not founded!', mtWarning, [mbOk], 0);
  end;

  result:=avviato;

end;




procedure TForm1.TimersRowMoved(Sender: TObject; FromIndex,
  ToIndex: Integer);
var  TempReg: array of RecData;
begin
  setlength(TempReg,1);
  Init(TempReg,0);
  TempReg[0]:=Reg[ToIndex-1];
  Reg[ToIndex-1]:=Reg[FromIndex-1];
  Reg[FromIndex-1]:=TempReg[0];
  SaveBtn.Enabled:=true;
end;





procedure TForm1.CheckVersion;
var RestarterVer:string;
    IniFile: TIniFile;
begin
  { controllo versioni dal web}

  RestarterVer:='1';

  DeleteFile(InfoFile);
  if CheckIntFile(NavURL+InfoFile) and GetInetFile(NavURL+InfoFile, InfoFile) then
  if FileExists(InfoFile) then
      begin
       IniFile:=TIniFile.Create(GetCurrentDir+'\'+InfoFile);
       RestarterVer:=IniFile.ReadString('RESTARTER','version','1');
       IniFile.Free;
       DeleteFile(InfoFile);
      end;

  updatedcheck:=(RestarterVer<>'1') AND (Version<RestarterVer);

end;





// ============================================  //
//
//                  FORM CREATE
//
// ============================================ //


procedure TForm1.FormDestroy(Sender: TObject);
begin
 Shell_NotifyIcon(NIM_DELETE, @FIconData);
 HideAllProc(true);
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
 //inizializzazioni
  RstPath:=ExtractFilePath(Application.ExeName);
  RstName:=ExtractFileName(Application.ExeName);
  RstNameNoExt:=FNameNoExt(RstName);
  bloccatutti:=false;
  //bloccarealm:=false;
  //ErrWindowName:='';
  Version:=VersioneApplicazione(RstPath+RstName);
  NavUrl:='http://udw.altervista.org/udwinfo/restarter/';
  InfoFile:='inform.ini';
  RstFolder:='restarter_files\';
  crescente:=true;
  AddIcon;

  hideallmenu.Hint:=hideall.Hint;
  stopallmenu.Hint:=stopall.Hint;
  addmenu.Hint:=add.Hint;
  savemenu.Hint:=Savebtn.Hint;

  // controllo versione
  Versione.Color:=clBlack;
  Versione.Caption:='Checking Version..';
  ThreadCreate(false);
  //showmessage(inttostr(Length(Reg))+' '+inttostr(High(Reg))+' '+inttostr(Low(Reg)));

  // il controllo dell'estensione ini non è case sensitive

  if CreaGriglia(true) then
    showmessage('Some process are already running');

  CheckEnabling;
  saveBtn.Enabled:=false;

  //Timers.Row:=1;  //assegna il primo nome della lista

  ChangeStopBtn(Timers.Row);
  ChangeHideBtn(Timers.Row);

  WebBrowser.Navigate(NavUrl+'stats.html?I=Restarter'+Version);

end;





// ============================================  //
//
//                  TIMERS
//
// ============================================ //



procedure TForm1.Timer1Timer(Sender: TObject);
Var
    I:integer;
    ris,codexit: cardinal;
begin


 if (NOT bloccatutti) then
 begin
  for I:=0 to AppNum-1 do  // con valore 0 non prosegue
   if (NOT Reg[I].blocca) then
   begin
    ris:=0;
    ris:=OpenProcess( PROCESS_QUERY_INFORMATION , false, Reg[I].APPInfo.dwProcessId );

    GetExitCodeProcess(ris,codexit);

    if (codexit=STATUS_PENDING) and (ris<>0) then
     begin
      Tempo2[I]:= now-Reg[I].Tempo1;
      timers.Cells[GrdUptime,I+1]  := TimeToStr(Tempo2[I]);

      if Reg[I].days<>-1 then
       if Reg[I].days <> strtoint(FormatDateTime('dd',Tempo2[I])) then  // da sistemare
       begin
        // Reg[I].Tempo1 := Now;
        Reg[I].days:= strtoint(FormatDateTime('dd',Tempo2[I]));
        inc(Reg[I].DiffDays);
        timers.Cells[GrdDays,I+1]  := inttostr(Reg[I].DiffDays);
       end
       else
      else
       begin
        Reg[I].days:=strtoint(FormatDateTime('dd',Tempo2[I]));
        Reg[I].DiffDays:=0;
        timers.Cells[GrdDays,I+1]:='0';
       end;

     end
     else
      begin
         CreateProcessSimple(Reg[I].APPPath,Reg[I].APPInfo);
         ResetUptime(Reg,I);

         inc(reg[I].restarts,1);
         Form1.timers.Cells[GrdRestarts,I+1]  := inttostr(reg[I].restarts);

      end;

      closehandle(ris);

    end;


 Timer.Caption:=timers.Cells[GrdUptime,Timers.Row];
 giorni.Caption:='Days: '+timers.Cells[GrdDays,Timers.Row];

end;
end;



procedure TForm1.Timer2Timer(Sender: TObject);
 var   wnd: HWND; //THandle;
       I:integer;
begin
 //10 secondi

 if (NOT bloccatutti) then
  for I:=0 to AppNum-1 do  // con valore 0 non prosegue
   if (NOT Reg[I].blocca) and (Reg[I].ErrWindowName<>'') then
   begin
       wnd:=FindWindow(nil,PAnsiChar(Reg[I].ErrWindowName));
       if wnd<>0 then
       begin
         PostMessage(wnd, WM_CLOSE, 0, 0);
       end;
   end

{ if ErrWindowName<>'' then
 begin
       wnd:=FindWindow(nil,PAnsiChar(ErrWindowName));
       if wnd<>0 then
       begin
         PostMessage(wnd, WM_CLOSE, 0, 0);
       end;    }


end;

//hackcode
procedure TForm1.Timer3Timer(Sender: TObject);
begin
  //10 minuti
 ThreadCreate(false);
end;



// ============================================  //
//
//                  PULSANTI
//
// ============================================ //



procedure TForm1.STOPClick(Sender: TObject);
begin
 StopProc(Timers.Row);
end;

procedure TForm1.StopAllClick(Sender: TObject);
var i:integer;
begin
  if NOT bloccatutti then
   begin
   bloccatutti:=true;

   for I:=0 to APPNum-1 do
    Reg[I].blocca:=true;

   StopAll.Caption:='START ALL';

  // bloccarealm:=true;
   //StopRealm.Caption:='START REALM';

   end
  else
  begin

    for I:=0 to APPNum-1 do
       if CheckFile(Reg[I].APPPath) then
       Reg[I].blocca:=false;

     bloccatutti:=false;

    StopAll.Caption:='STOP ALL';

  //  bloccarealm:=false;
   // StopRealm.Caption:='STOP REALM';
  end;

  stopallmenu.Caption:=StopAll.Caption;
  changestopbtn(timers.Row);

end;

 {
procedure TForm1.StopRealmClick(Sender: TObject);
begin
 if NOT bloccarealm then
 begin
   bloccarealm:=true;
 //  StopRealm.Caption:='START GROUP:';
 end
 else
 begin
   bloccarealm:=false;
 //  StopRealm.Caption:='STOP GROUP:';
 end;


end;
 }


procedure TForm1.CleanClick(Sender: TObject);
begin
    timers.Cells[GrdRestarts,Timers.row]:='0';
    reg[Timers.row-1].restarts:=0;
end;

procedure TForm1.licenseClick(Sender: TObject);
begin
  
end;

{
procedure TForm1.TimersClick(Sender: TObject);
begin
   MangosSel.ItemIndex:=timers.Selection.Top-1;
   MangosSelChange(Sender);
   timers.SetFocus;
end;
}

procedure TForm1.uptimeClick(Sender: TObject);
begin
     ResetUptime(Reg,Timers.row-1);
end;

procedure TForm1.AddClick(Sender: TObject);
begin
  Spec1.DisableBox.visible:=true;
  Spec1.OpenDialog1.Execute;
end;

procedure TForm1.TimersSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  ChangeStopBtn(ARow);
  ChangeHideBtn(Arow);
end;

procedure TForm1.DelClick(Sender: TObject);
begin
  delrow(Timers.Row);
  // seleziona la prima riga precedente disponibile
if Timers.row>1 then
begin
  Timers.Row:=Timers.Row-1;
  while (Timers.Row>1) and (Reg[Timers.Row-1].deleted) do
   Timers.Row:=Timers.Row-1;
end;
end;

procedure TForm1.RestoreBtnClick(Sender: TObject);
var I,ID:integer;
begin

 ID:=MessageDlg('It will restore all processes from the last save, are you sure? ',mtInformation,[mbYes,mbNo] ,0);

 if ID=IDYES then
 begin

 //ErrWindow.Text:=ErrWindowName;

  For I:=0 to AppNum-1 do
  begin
   if Reg[I].deleted=true then
   begin
      Timers.RowHeights[I+1]:=Timers.DefaultRowHeight; //effetto delete
      Reg[I].deleted:=false;
      Reg[I].blocca:=true;
      inc(Form1.ProcCount);
   end;

   if Reg[I].added=true then
    begin
     delrow(I+1); // +1 poichè è relativo alle row
    end;
 end;

 ChangeStopBtn(Timers.Row);

 CheckEnabling;

 end;

end;
{
procedure TForm1.UpDown1Click(Sender: TObject; Button: TUDBtnType);
var I:integer;
begin

 I:=Timers.Row;

  if (Button<>BtPrev) then
  begin
    if (i>1)  then
     inc(I,-1);
  end
  else
   if (i<Timers.RowCount-1) then
    inc(I);

  Timers.Row:=I;
end;
 }

procedure TForm1.SaveBtnClick(Sender: TObject);
begin
  CreateIniFile(RstPath+RstFolder);
  EnableRestarter(false);
  CreaGriglia(false);
  ChangeStopBtn(Timers.Row);
  CheckEnabling;
  SaveBtn.Enabled:=false;
  RestoreBtn.Enabled:=false;
end;



procedure TForm1.TimersClick(Sender: TObject);
begin
 //mostra la row evitando di effettuare il size
  if (Timers.col=GrdPath) and (Timers.row>0) then
  begin
   showmessage(Timers.Cells[GrdPath,Timers.row]);
   Timers.ColWidths[GrdPath]:=Timers.DefaultColWidth;
  end;

end;

procedure TForm1.EditClick(Sender: TObject);
begin
   Spec1.DisableBox.visible:=false;
   Spec1.SelRow:=timers.Row;
   Spec1.Show;
end;

procedure TForm1.VersioneClick(Sender: TObject);
begin
  ExecuteFile(NavUrl+'redirects.php?selection=restarter_download', '', '', 0);
end;

procedure TForm1.ErrWindowChange(Sender: TObject);
begin
  savebtn.Enabled:=true;
  restorebtn.Enabled:=true;
end;


procedure TForm1.ExitMenuClick(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TForm1.TimersMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var c,j:integer;
  rect:trect;
begin
  with Timers do
  if y<rowheights[0] then   {make sure row 0 was clicked}
  begin
    for j:= 0 to colcount-1 do {determine which column was clicked}
    begin
      rect := cellrect(j,0);
      if (rect.Left < x) and (rect.Right> x) then
      begin
        c := j;
        break;
      end;
    end;
    sortgrid(Timers,c);
  end;
end;

procedure TForm1.TrayClick(Sender: TObject);
begin
     Application.Minimize;
     AppMinimize(@Self);
     Visible:=false;
end;

procedure TForm1.BugSectionExecute(Sender: TObject);
begin
   ExecuteFile(NavUrl+'redirects.php?selection=bug_section', '', '', 0);
end;

procedure TForm1.AboutExecute(Sender: TObject);
begin
  MessageDlg('UDW Restarter '+version+'Freeware Software created by HW2-Yéhonal'#13#10'from UDW-Community (United Developers World)',mtInformation,[mbOK],0);
  ExecuteFile(NavUrl+'redirects.php?selection=restarter_btn', '', '', 0);
end;


procedure Tform1.HideProc(row:integer;forceshow:boolean);
  var hw:HWND;
      rec:integer;
begin

if (row>=1) then
begin

 rec:=row-1;

 hw:=WindowFromProcessID(reg[rec].APPInfo.dwProcessId);

 if not (forceshow) and ( (IsWindowVisible( hw )) or (IsIconic(hw)) ) then
 begin
  Reg[rec].nascosto:=true;
  ShowWindow(hw, SW_HIDE);
 end
 else
 begin
  Reg[rec].nascosto:=false;
  ShowWindow(hw, SW_SHOW);
 end;

end;

end;


procedure TForm1.HideClick(Sender: TObject);
begin
  HideProc(timers.row,false);
  ChangeHideBtn(timers.row);
end;


procedure TForm1.HideAllClick(Sender: TObject);
begin
 HideAllProc(false);
 changehidebtn(timers.Row);
end;

end.


