object Spec1: TSpec1
  Left = 805
  Top = 507
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Setting'
  ClientHeight = 149
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object NameApp: TLabeledEdit
    Left = 16
    Top = 24
    Width = 121
    Height = 21
    Hint = 'Insert the name of this process'
    EditLabel.Width = 66
    EditLabel.Height = 13
    EditLabel.Caption = 'Insert a Name'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object OkBtn: TBitBtn
    Left = 112
    Top = 112
    Width = 75
    Height = 25
    TabOrder = 1
    OnClick = OkBtnClick
    Kind = bkOK
    Layout = blGlyphRight
  end
  object AnnullBtn: TBitBtn
    Left = 200
    Top = 112
    Width = 75
    Height = 25
    TabOrder = 2
    OnClick = AnnullBtnClick
    Kind = bkAbort
    Layout = blGlyphRight
  end
  object DisableBox: TCheckBox
    Left = 16
    Top = 104
    Width = 97
    Height = 17
    Hint = 'Disable the checking on this process for now'
    Caption = 'Disable'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object ErrWin: TLabeledEdit
    Left = 16
    Top = 72
    Width = 121
    Height = 21
    Hint = 'Insert the name of the error window that you want to auto close'
    EditLabel.Width = 95
    EditLabel.Height = 13
    EditLabel.Caption = 'Error Window Name'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.exe'
    Filter = 'EXE (*.exe)|*.exe|All Files (*.*)|*.*'
    OnCanClose = OpenDialog1CanClose
    Left = 192
    Top = 16
  end
end
