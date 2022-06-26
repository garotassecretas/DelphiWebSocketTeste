unit ListadeComandos;

interface

uses
  Windows, System.SysUtils, IdContext, WebSocketServer, Vcl.Graphics, JPEG, IdCoderMIME,  System.Classes, System.JSON;

  type

    TWebSocketCommands = class
    private
      FServer: TWebSocketServer;
      io: TWebSocketIOHandlerHelper;
      procedure Connect(AContext: TIdContext);
      procedure Disconnect(AContext: TIdContext);
      procedure Execute(AContext: TIdContext);
    public
      constructor Create;
      destructor Destroy; override;
    end;

  { TWebSocketDemo }

implementation

uses
  Unit1;

  constructor TWebSocketCommands.Create;
  begin
    FServer := TWebSocketServer.Create;
    FServer.DefaultPort := WebSocketPort;
    FServer.OnExecute := Execute;
    FServer.OnConnect := Connect;
    FServer.OnDisconnect := Disconnect;
    FServer.Active := true;
  end;

  destructor TWebSocketCommands.Destroy;
  begin
    FServer.Active := false;
    FServer.DisposeOf;
    inherited;
  end;

  procedure TWebSocketCommands.Connect(AContext: TIdContext);
  begin
    //ListLog.Add('Client connected');
  end;

  procedure TWebSocketCommands.Disconnect(AContext: TIdContext);
  begin
    //ListLog.Add('Client disconnected');
  end;

  procedure TWebSocketCommands.Execute(AContext: TIdContext);
  var
    drivespacemsg, driveunit, msg, msgout: string;
    cmdkey, cmdval: string;
    LastFrameBitmap:  TBitmap;
    jsonObj, jsonSenderObj: TJSONObject;
    WebcamPathTemp, DesktopPathTemp: string;
    errorcmd: Boolean;
  begin
    io := TWebSocketIOHandlerHelper(AContext.Connection.IOHandler);
    io.CheckForDataOnSource(10);
    msg := io.ReadString;

    if msg = '' then
      exit;

    cmdkey := 'emptycmd';
    cmdval := 'emptyval';

    jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(msg), 0) as TJSONObject;
    if jsonObj <> nil then
    try
      cmdkey := jsonObj.GetValue<string>('cmdkey', 'emptycmd');
      OutputDebugString(PWideChar(cmdkey));

      cmdval := jsonObj.GetValue<string>('cmdvalue', 'emptyval');
      OutputDebugString(PWideChar(cmdval));
    finally
      jsonObj.Free;
    end;

    try
      jsonSenderObj := TJSONObject.Create;

        if cmdkey.Trim.Equals('helloserver') then
        begin
          jsonSenderObj.AddPair('returnkey', 'helloresponseok');
        end
        else
        if cmdkey.Trim.Equals('ligarbotao') then
        begin
          Form1.TesteAtivar;
          jsonSenderObj.AddPair('returnkey', 'testeligado');
        end
        else
        if cmdkey.Trim.Equals('desligarbotao') then
        begin
          Form1.TesteDesativar;
          jsonSenderObj.AddPair('returnkey', 'testedesligado');
        end
        else
         jsonSenderObj.AddPair('returnkey', 'invalidcommand');


        jsonSenderObj.AddPair('msgsend', msg);

      msgout := jsonSenderObj.ToString;
    except
      msgout := '{"returnkey": "errorjsonreturn"}';
    end;

    io.WriteString(msgout);
    Form1.Memo1.Lines.Add(msgout);
    jsonSenderObj.DisposeOf;
  end;

end.
