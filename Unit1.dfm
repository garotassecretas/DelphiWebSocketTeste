object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 418
  ClientWidth = 727
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnbotton: TPanel
    Left = 0
    Top = 100
    Width = 727
    Height = 318
    Align = alClient
    Constraints.MinHeight = 150
    Constraints.MinWidth = 300
    TabOrder = 0
    object Memo1: TMemo
      AlignWithMargins = True
      Left = 11
      Top = 11
      Width = 705
      Height = 296
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      TabOrder = 0
    end
  end
  object pntop: TPanel
    Left = 0
    Top = 0
    Width = 727
    Height = 100
    Align = alTop
    Constraints.MinHeight = 100
    Constraints.MinWidth = 300
    TabOrder = 1
    DesignSize = (
      727
      100)
    object Label1: TLabel
      Left = 599
      Top = 13
      Width = 35
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Status:'
      ExplicitLeft = 607
    end
    object Label3: TLabel
      Left = 10
      Top = 8
      Width = 14
      Height = 13
      Caption = 'IP:'
    end
    object lblLocalIP: TLabel
      Left = 34
      Top = 8
      Width = 112
      Height = 13
      Caption = '000.000.000.000:0000'
    end
    object lblStatus: TLabel
      Left = 640
      Top = 13
      Width = 68
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Desconectado'
      Color = clRed
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ExplicitLeft = 648
    end
    object btnConnect: TButton
      Left = 511
      Top = 8
      Width = 80
      Height = 25
      Anchors = [akTop]
      Caption = 'Conectar'
      TabOrder = 0
      OnClick = btnConnectClick
    end
    object CheckBox1: TCheckBox
      Left = 349
      Top = 52
      Width = 153
      Height = 17
      Caption = 'Check Ligado / Desligado'
      TabOrder = 1
    end
    object Button1: TButton
      Left = 209
      Top = 48
      Width = 122
      Height = 25
      Caption = 'TESTE LiGA DESLIGA'
      TabOrder = 2
      OnClick = Button1Click
    end
  end
end
