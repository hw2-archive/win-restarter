object Form1: TForm1
  Left = 722
  Top = 546
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Restarter'
  ClientHeight = 362
  ClientWidth = 599
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Versione: TLabel
    Left = 16
    Top = 328
    Width = 111
    Height = 14
    Cursor = crHandPoint
    Hint = 'Click here to download the Restarter'
    Caption = 'Checking Version..'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    OnClick = VersioneClick
  end
  object Timers: TStringGrid
    Left = 14
    Top = 155
    Width = 547
    Height = 128
    Hint = 'you can order fields clicking on first row'
    ColCount = 7
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goRowMoving]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = TimersClick
    OnMouseUp = TimersMouseUp
    OnRowMoved = TimersRowMoved
    OnSelectCell = TimersSelectCell
    ColWidths = (
      65
      89
      64
      64
      64
      64
      123)
  end
  object SecCount: TComboBox
    Left = 520
    Top = 296
    Width = 73
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Visible = False
  end
  object SaveBtn: TBitBtn
    Left = 200
    Top = 288
    Width = 73
    Height = 25
    Cursor = crHandPoint
    Hint = 'Save permanently the processes'
    Caption = '&Save'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = SaveBtnClick
    Kind = bkAll
  end
  object RestoreBtn: TBitBtn
    Left = 280
    Top = 288
    Width = 73
    Height = 25
    Cursor = crHandPoint
    Hint = 'Restore the last saved state'
    Caption = '&Restore'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = RestoreBtnClick
    Kind = bkRetry
  end
  object WebBrowser: TWebBrowser
    Left = 376
    Top = 0
    Width = 640
    Height = 0
    TabOrder = 4
    ControlData = {
      4C00000025420000000000000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E12620A000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object ProcName: TGroupBox
    Left = 16
    Top = 40
    Width = 497
    Height = 105
    Caption = 'ProcName'
    TabOrder = 5
    object Timer: TLabel
      Left = 147
      Top = 24
      Width = 70
      Height = 22
      Caption = '0.00.00'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = 'Lucida Sans'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object giorni: TLabel
      Left = 8
      Top = 24
      Width = 46
      Height = 20
      Caption = 'Days:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object STOP: TButton
      Left = 320
      Top = 24
      Width = 65
      Height = 20
      Cursor = crHandPoint
      Hint = 'Start/Stop the checking on the selected process'
      Caption = 'STOP'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Impact'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = STOPClick
    end
    object GroupBox1: TGroupBox
      Left = 400
      Top = 19
      Width = 89
      Height = 78
      Caption = 'Clean:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial Black'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object Clean: TButton
        Left = 8
        Top = 24
        Width = 49
        Height = 17
        Cursor = crHandPoint
        Hint = 'Clean the restart counter of the selected process'
        Caption = 'restart'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = CleanClick
      end
      object uptime: TButton
        Left = 8
        Top = 48
        Width = 49
        Height = 17
        Cursor = crHandPoint
        Hint = 'Clean the uptime of the selected process'
        Caption = 'uptime'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = uptimeClick
      end
    end
    object Del: TBitBtn
      Left = 80
      Top = 72
      Width = 65
      Height = 20
      Cursor = crHandPoint
      Hint = 'Delete the selected process from the grid'
      Caption = 'Delete'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = DelClick
      Kind = bkCancel
      Layout = blGlyphRight
    end
    object Edit: TButton
      Left = 8
      Top = 72
      Width = 65
      Height = 20
      Cursor = crHandPoint
      Hint = 'edit the selected process'
      Caption = 'Edit'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = EditClick
    end
    object Hide: TButton
      Left = 320
      Top = 48
      Width = 65
      Height = 20
      Cursor = crHandPoint
      Hint = 'hide/show only console applications'
      Caption = 'HIDE'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Impact'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = HideClick
    end
  end
  object Add: TBitBtn
    Left = 515
    Top = 112
    Width = 30
    Height = 33
    Cursor = crHandPoint
    Hint = 'Add a new process in the grid'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnClick = AddClick
    Glyph.Data = {
      16020000424D160200000000000076000000280000001A0000001A0000000100
      040000000000A001000000000000000000001000000000000000000000000000
      BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
      7777777777777700000077777777777777777777777777000000777777777777
      77777777777777000000777777777778888877777777770000007777777777FA
      AAAA87777777770000007777777777FAAAAA87777777770000007777777777FA
      AAAA87777777770000007777777777FAAAAA87777777770000007777777777FA
      AAAA87777777770000007777777777FAAAAA877777777700000077778888888A
      AAAA8888888777000000777FAAAAAAAAAAAAAAAAAAA877000000777FAAAAAAAA
      AAAAAAAAAAA877000000777FAAAAAAAAAAAAAAAAAAA877000000777FAAAAAAAA
      AAAAAAAAAAA8770000007777FFFFFFFAAAAA8FFFFFF7770000007777777777FA
      AAAA87777777770000007777777777FAAAAA87777777770000007777777777FA
      AAAA87777777770000007777777777FAAAAA87777777770000007777777777FA
      AAAA87777777770000007777777777FAAAAA877777777700000077777777777F
      FFFF777777777700000077777777777777777777777777000000777777777777
      7777777777777700000077777777777777777777777777000000}
    Layout = blGlyphRight
  end
  object StopAll: TButton
    Left = 515
    Top = 48
    Width = 57
    Height = 25
    Cursor = crHandPoint
    Hint = 'Start/Stop the cheking on all processes'
    Caption = 'STOP ALL'
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Impact'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = StopAllClick
  end
  object Tray: TBitBtn
    Left = 496
    Top = 328
    Width = 91
    Height = 17
    Hint = 'Minimize the restarter to your tray'
    Caption = 'Minimize To Tray'
    TabOrder = 8
    OnClick = TrayClick
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 599
    Height = 24
    UseSystemFont = False
    ActionManager = ActionManager1
    Caption = 'ActionMainMenuBar1'
    ColorMap.HighlightColor = 16579837
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = 16579837
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Spacing = 0
  end
  object HideAll: TButton
    Left = 515
    Top = 80
    Width = 81
    Height = 25
    Cursor = crHandPoint
    Hint = 'Hide/Show all console applications'
    Caption = 'HIDE/SHOW ALL'
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Impact'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
    OnClick = HideAllClick
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 416
    Top = 288
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = Timer2Timer
    Left = 440
    Top = 288
  end
  object Timer3: TTimer
    Interval = 600000
    OnTimer = Timer3Timer
    Left = 464
    Top = 288
  end
  object PopupMenu1: TPopupMenu
    Left = 488
    Top = 288
    object hideallmenu: TMenuItem
      Caption = 'HIDE/SHOW ALL'
      Hint = 'hideall'
      OnClick = HideAllClick
    end
    object stopallmenu: TMenuItem
      Caption = 'STOP ALL'
      Hint = 'stopall'
      OnClick = StopAllClick
    end
    object AddMenu: TMenuItem
      Caption = 'Add Process'
      Hint = 'add'
      OnClick = AddClick
    end
    object SaveMenu: TMenuItem
      Caption = 'Save'
      Hint = 'save'
      OnClick = SaveBtnClick
    end
    object ExitMenu: TMenuItem
      Caption = 'Exit'
      Hint = 'exit'
      OnClick = ExitMenuClick
    end
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = BugSection
                Caption = '&Help && Bug Section'
              end
              item
                Action = About
                Caption = '&About..'
              end>
            Caption = '&Help'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Left = 392
    Top = 288
    StyleName = 'XP Style'
    object BugSection: TAction
      Category = 'Help'
      Caption = 'Help && Bug Section'
      OnExecute = BugSectionExecute
    end
    object About: TAction
      Category = 'Help'
      Caption = 'About..'
      OnExecute = AboutExecute
    end
  end
end
