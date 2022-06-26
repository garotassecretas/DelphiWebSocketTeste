program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  ListaDeComandos in 'WebSocket\ListaDeComandos.pas',
  Web.Win.Sockets in 'WebSocket\Web.Win.Sockets.pas',
  WebSocketServer in 'WebSocket\WebSocketServer.pas',
  WebHttPages in 'httpserver\WebHttPages.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
