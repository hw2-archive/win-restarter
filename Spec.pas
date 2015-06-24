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

unit Spec;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TSpec1 = class(TForm)
    NameApp: TLabeledEdit;
    OkBtn: TBitBtn;
    AnnullBtn: TBitBtn;
    OpenDialog1: TOpenDialog;
    DisableBox: TCheckBox;
    ErrWin: TLabeledEdit;
    Procedure HandleClose(arg:string;arg2:string;row:integer);
    procedure OkBtnClick(Sender: TObject);
    procedure OpenDialog1CanClose(Sender: TObject; var CanClose: Boolean);
    procedure AnnullBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    SelRow:integer;
  end;

var
  Spec1: TSpec1;

implementation

uses Restart,engine;
{$R *.dfm}


Procedure TSpec1.HandleClose(arg:string;arg2:string;row:integer);
var I:integer;
begin

if row=-1 then
 begin
  inc(Form1.ProcCount);
  inc(Form1.APPNum);

  I:=Length(Reg)+1;

  SetLength(Reg,I);
  SetLength(Form1.Tempo2,I);

  I:=High(Reg);

  Init(Reg,I);
  Reg[I].APPName:=Arg;
  Reg[I].APPPath:=expandfilename(OpenDialog1.FileName);
  Reg[I].blocca:=DisableBox.Checked;
  Reg[I].added:=true;
  Reg[I].ErrWindowName:=arg2;

  Form1.Timers.RowCount:=Form1.Timers.RowCount+1;//:=Form1.ProcCount+1;
  Form1.Timers.Rows[I+1].Clear;

  Form1.Timers.cols[GrdName].Add(Arg);
  Form1.Timers.Cols[GrdPath].Add(expandfilename(OpenDialog1.FileName));
  Form1.Timers.cols[GrdID].Add('NEWAPP'+inttostr(Form1.ProcCount));
  Form1.Timers.cols[GrdErrWin].Add(arg2);

  Form1.Timers.row:=I+1; //anticrash per l'handlename


  Form1.CheckEnabling;

  // ora se tutto e pronto e se i timers erano spenti li avvia
 end
 else
   begin
     Reg[row-1].APPName:=arg;
     Reg[row-1].ErrWindowName:=arg2;
     Form1.Timers.Cells[grdname,row]:=arg;
     Form1.Timers.Cells[grderrwin,row]:=arg2;
   end;


 Form1.HandleName(arg,Form1.Timers.row);
 Form1.ChangeStopBtn(Form1.Timers.row); // dopo l'handle
 Form1.SaveBtn.Enabled:=true;
 Form1.RestoreBtn.Enabled:=true;

 Spec1.Close;

end;

procedure TSpec1.OkBtnClick(Sender: TObject);
begin
 if DisableBox.visible then
  HandleClose(NameApp.Text,ErrWin.text,-1)
 else
  HandleClose(NameApp.Text,ErrWin.text,SelRow);
end;

procedure TSpec1.OpenDialog1CanClose(Sender: TObject;
  var CanClose: Boolean);
begin
   Spec1.Show;
end;

procedure TSpec1.AnnullBtnClick(Sender: TObject);
begin
   Spec1.close;
end;

procedure TSpec1.FormShow(Sender: TObject);
begin
 form1.Enabled:=false;

 if DisableBox.visible then
 begin
  NameApp.Text:='';
  ErrWin.Text:='';
 end
 else
 begin
  NameApp.Text:=Form1.Timers.Cells[grdname,SelRow];
  ErrWin.Text:=Form1.Timers.Cells[grderrwin,SelRow];;
 end;
end;

procedure TSpec1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 form1.Enabled:=true;
end;

end.
