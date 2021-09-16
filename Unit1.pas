unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, WebFunctions, Bird.Socket;

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
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    TestWebServ: TWebServer;
    FBirdSocket: TBirdSocket;
    procedure SConnect;
    procedure SDisconnect;
    procedure ActivateDeactivate;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  HostIp: String;

implementation

{$R *.dfm}

procedure TForm1.SConnect;
begin
  if not(WebFunctions.isConnected) then
    begin
      btnConnect.Caption := 'Desconectar';
      lblStatus.Caption := 'Conectado';
      lblStatus.Font.Color := clLime;
      WebFunctions.isConnected := true;
      TestWebServ := TWebServer.Create;
      FBirdSocket.Start;

      Memo1.Lines.Add('Servidor Iniciado no Host :' + HostIp+':'+WebPort.ToString);
    end;
end;

procedure TForm1.SDisconnect;
begin
  if WebFunctions.isConnected then
    begin
     btnConnect.Caption := 'Conectar';
     lblStatus.Caption := 'Desconectado';
     lblStatus.Font.Color := clRed;
     WebFunctions.isConnected := false;
     TestWebServ.WebClose;
       if FBirdSocket.Active then
        begin
          //FBirdSocket.DisposeOf; trava o programa
          FBirdSocket.Stop;
          //FBirdSocket.Free; // trava o programa
        end;

     Memo1.Lines.Add('Servidor foi Desligado');
    end;
end;

procedure TForm1.ActivateDeactivate;
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

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  if WebFunctions.isConnected then
      SDisconnect
    else
      SConnect;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ActivateDeactivate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  HostIp := GetIPAddress;
  lblLocalIP.Caption := HostIp+':'+WebPort.ToString;
  FBirdSocket := TBirdSocket.Create(WebPort+1);

  try
    FBirdSocket.AddEventListener(TEventType.CONNECT,
      procedure(const ABird: TBirdSocketConnection)
      begin
        Memo1.Lines.Add(Format('Client %s connected.', [ABird.IPAdress]));
      end);

    FBirdSocket.AddEventListener(TEventType.EXECUTE,
      procedure(const ABird: TBirdSocketConnection)
      var
        LMessage: string;
      begin
        LMessage := ABird.WaitMessage;

        if LMessage.Trim.Equals('ping') then
        begin
          ABird.Send('pong');
          {*  COLOQUE AQUI O COMANDO QUE VAI EXECUTAR NO PC*}
        end
        else
        if LMessage.Trim.Equals('tstcommand') then
        begin
          ActivateDeactivate;
          ABird.Send('Testado ok');
        end
        else
        if LMessage.Trim.IsEmpty then
        begin
          {*  COLOQUE AQUI O COMANDO QUE VAI EXECUTAR NO PC*}
          ABird.Send('empty message');
        end
        else
          ABird.Send(Format('message received: "%s"', [LMessage]));

        Memo1.Lines.Add(Format('Message received from %s: %s.', [ABird.IPAdress, LMessage]));
      end);

    FBirdSocket.AddEventListener(TEventType.DISCONNECT,
      procedure(const ABird: TBirdSocketConnection)
      begin
        Memo1.Lines.Add(Format('Client %s disconnected.', [ABird.IPAdress]));
      end);

    SConnect;

  finally
    //FBirdSocket.DisposeOf; // essa linha desconecta tudo e deve ser removida
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SDisconnect;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  // FBirdSocket.Free; trava o programa e continua sendo executado no windows mesmo depois de fechar
end;

end.
