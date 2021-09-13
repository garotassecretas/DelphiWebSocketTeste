unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    lblStatus: TLabel;
    btnConnect: TButton;
    Memo1: TMemo;
    Label3: TLabel;
    lblLocalIP: TLabel;
    pnbotton: TPanel;
    pntop: TPanel;
    CheckBox1: TCheckBox;
    Button1: TButton;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  HostIp: String;

implementation

{$R *.dfm}

uses
  WebFunctions;

var
  TestWebServ: TWebServer;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  if WebFunctions.isConnected then
    begin
     btnConnect.Caption := 'Conectar';
     lblStatus.Caption := 'Desconectado';
     lblStatus.Font.Color := clRed;
     WebFunctions.isConnected := false;
     TestWebServ.WebClose;
    end
  else
    begin
      btnConnect.Caption := 'Desconectar';
      lblStatus.Caption := 'Conectado';
      lblStatus.Font.Color := clLime;
      WebFunctions.isConnected := true;
      TestWebServ := TWebServer.Create;

      Memo1.Lines.Add('Servidor Iniciado no Host :' + HostIp+':'+WebPort.ToString);
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
  begin
    Button1.Caption := 'Teste Desligado';
    CheckBox1.Checked := false;
  end
    else
  begin
    Button1.Caption := 'Teste Ligado';
    CheckBox1.Checked := true;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  HostIp := GetIPAddress;
  lblLocalIP.Caption := HostIp+':'+WebPort.ToString;
end;

end.
