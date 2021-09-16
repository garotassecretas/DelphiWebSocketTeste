object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 418
  ClientWidth = 735
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnbotton: TPanel
    Left = 0
    Top = 137
    Width = 735
    Height = 281
    Align = alClient
    Constraints.MinHeight = 150
    Constraints.MinWidth = 300
    TabOrder = 0
    object Memo1: TMemo
      AlignWithMargins = True
      Left = 11
      Top = 11
      Width = 713
      Height = 259
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
    Width = 735
    Height = 137
    Align = alTop
    Constraints.MinHeight = 100
    Constraints.MinWidth = 300
    TabOrder = 1
    DesignSize = (
      735
      137)
    object Label1: TLabel
      Left = 615
      Top = 8
      Width = 35
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Status:'
      ExplicitLeft = 185
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
      Left = 656
      Top = 8
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
      ExplicitLeft = 226
    end
    object Label2: TLabel
      Left = 169
      Top = 46
      Width = 374
      Height = 39
      Caption = 
        'Gostaria que os itens abaixo fossem ligados ou desligados, tanto' +
        ' direto pelo proprio programa quanto remotamente pelo websocket ' +
        'via c'#243'digo em HTML. OBS.: N'#227'o precisaria de servidor pois seria ' +
        'feito pela mesma rede e n'#227'o online'
      WordWrap = True
    end
    object btnConnect: TButton
      Left = 349
      Top = 8
      Width = 80
      Height = 25
      Anchors = [akBottom]
      Caption = 'Conectar'
      TabOrder = 0
      OnClick = btnConnectClick
    end
    object CheckBox1: TCheckBox
      Left = 349
      Top = 104
      Width = 153
      Height = 17
      Caption = 'Check Ligado / Desligado'
      TabOrder = 1
    end
    object Button1: TButton
      Left = 209
      Top = 100
      Width = 122
      Height = 25
      Caption = 'TESTE LiGA DESLIGA'
      TabOrder = 2
      OnClick = Button1Click
    end
  end
end
