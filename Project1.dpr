program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  WebFunctions in 'WebFunctions.pas',
  Bird.Socket.Connection in 'BirdSocketSrc\Bird.Socket.Connection.pas',
  Bird.Socket.Consts in 'BirdSocketSrc\Bird.Socket.Consts.pas',
  Bird.Socket.Helpers in 'BirdSocketSrc\Bird.Socket.Helpers.pas',
  Bird.Socket in 'BirdSocketSrc\Bird.Socket.pas',
  Bird.Socket.Server in 'BirdSocketSrc\Bird.Socket.Server.pas',
  Bird.Socket.Types in 'BirdSocketSrc\Bird.Socket.Types.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
