unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  WebHttPages, ListaDeComandos;

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
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    WebServHttPages: TWebServer;
    WebServCommands: TWebSocketCommands;
    procedure SConnect;
    procedure SDisconnect;
    procedure ActivateDeactivate;
  public
    { Public declarations }
    procedure TesteAtivar;
    procedure TesteDesativar;
  end;

var
  Form1: TForm1;
  HostIp: String;

const
  HttpServerPort = 8181;
  WebSocketPort = 8182;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  HostIp := GetIPAddress;
  lblLocalIP.Caption := HostIp+':'+HttpServerPort.ToString;

end;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  if WebHttPages.isConnected then
      SDisconnect
    else
      SConnect;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ActivateDeactivate;
end;

procedure TForm1.SConnect;
begin
  if not(WebHttPages.isConnected) then
    begin
      try
        // Inicia o Servidor HTTP
        WebServHttPages := TWebServer.Create;
        WebHttPages.isConnected := true;
        // Inicia o WebSocket
        WebServCommands := TWebSocketCommands.Create;

        // Muda o Status do botão de Desconectado para Conectado
        btnConnect.Caption := 'Desconectar';
        lblStatus.Caption := 'Conectado';
        lblStatus.Font.Color := clLime;
      except
        on E: Exception do
           Memo1.Lines.Add(E.Message);
      end;

      Memo1.Lines.Add('Servidor Iniciado no Host :' + HostIp+':'+HttpServerPort.ToString);
      Memo1.Lines.Add('WebSocket : ws://' + HostIp+':'+WebsocketPort.ToString);
    end;
end;

procedure TForm1.SDisconnect;
begin
  if WebHttPages.isConnected then
    begin
      // Desliga o Servidor HTTP
     WebServHttPages.WebClose;
     WebHttPages.isConnected := false;

     // Desliga o Websocket
     WebServCommands.Destroy;

     // Muda o Status do botão de Conectado para Desconectado
     btnConnect.Caption := 'Conectar';
     lblStatus.Caption := 'Desconectado';
     lblStatus.Font.Color := clRed;

     Memo1.Lines.Add('Servidor foi Desligado');
    end;
end;

procedure TForm1.ActivateDeactivate;
begin
  if CheckBox1.Checked then
  begin
    TesteDesativar;
  end
    else
  begin
    TesteAtivar;
  end;
end;

procedure TForm1.TesteAtivar;
begin
    Button1.Caption := 'Teste Ligado';
    CheckBox1.Checked := true;
end;

procedure TForm1.TesteDesativar;
begin
    Button1.Caption := 'Teste Desligado';
    CheckBox1.Checked := false;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SDisconnect;
end;

end.
