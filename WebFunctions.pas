unit WebFunctions;

interface

uses
  SysUtils, Winapi.Windows, System.Classes, Winsock, Vcl.StdCtrls, Web.Win.Sockets, IdContext;

function GetIPAddress(): String;
const
  WebPort = 8081;

var
  isConnected: boolean;
  WebServer: TTcpServer;

Type
  TWebServer = Class
  Public
   Procedure WebServerAccept(Sender:TObject; ClientSocket:TCustomipClient);
   Constructor Create();
   Procedure WebClose();
  End;

implementation

uses
  Unit1;

Constructor TWebServer.Create;
begin
  WebServer := TTcpServer.Create(nil);
  WebServer.LocalPort := WebPort.ToString;
  //WebServer.LocalHost := GetIPAddress;
  WebServer.OnAccept := WebServerAccept;
  Webserver.Open;
end;

Procedure TWebServer.WebClose;
begin
  Webserver.Close;
  Webserver.Destroy;
end;

Procedure TWebServer.WebServerAccept(Sender:TObject; ClientSocket:TCustomipClient);
var
  RawData,Path,Agent,RawAgent:String;
  HttpPos,AgentPos:Integer;
  TRequestHeader:TStringList;
  TFileRequest:TStringList;
  i : Integer;
begin
  RawData := '';
  TRequestHeader := TStringList.create;
  TFileRequest := TStringList.create;

  while ClientSocket.Connected do
    begin
      RawData := ClientSocket.receiveLn();
      Form1.Memo1.Lines.Add('############ 01 #############'+RawData);
      OutputDebugString(PChar('############ 01 #############'+RawData));
      while RawData <> '' do
        begin
          TRequestHeader.Add(RawData);
          RawData := ClientSocket.receiveLn();
          OutputDebugString(PChar('############ 02 #############'+RawData));
          Form1.Memo1.Lines.Add('############ 02 #############'+RawData);
        end;

      for i := 0 to TRequestHeader.Count -1 do
        begin

          if TRequestHeader.Strings[i] = '' then
            begin
              Sleep(100);
              Continue;
            end;

          if Pos('User-Agent:', TRequestHeader.Strings[i]) > 0 then
            begin
              RawAgent := TRequestHeader.Strings[i];
              AgentPos := Pos('User-Agent:',RawAgent);
              Agent := Copy(RawAgent,13,Length(RawAgent)-12);
            end;

          if Copy(TRequestHeader.Strings[i],1,3) = 'GET' then
            begin
              HttpPos := Pos('HTTP', TRequestHeader.Strings[i]);
              Path := Copy(TRequestHeader.Strings[i],5,HttpPos -6);
            end;

        end;

        if (Path = '/') OR (Path = '') then
          Path := '/index.html';

        if (Path = '/teste') then
        begin
            ClientSocket.Sendln('HTTP/1.0 200 OK');
            ClientSocket.Sendln('Server: WebApp/1.0 (Win64) by TestAplications');
            ClientSocket.Sendln('Content-Type: text/html');
            ClientSocket.Sendln('');
            ClientSocket.sendLn('<!DOCTYPE html><html><meta name="viewport" content="width=device-width, initial-scale=1.0"><head><title>WebSocket Html</title></head><body>TESTE PAGINA INTERNA<script>');
            ClientSocket.sendLn('const socket = new WebSocket("ws://'+GetIPAddress+':'+WebPort.ToString+'");');
            ClientSocket.sendLn('</script></body></html>');
            //ClientSocket.Close;
            Exit;
        end
        else if FileExists(GetCurrentDir + '\www'+ Path) then
          begin
            TFileRequest.LoadFromFile(GetCurrentDir + '\www'+ Path);
            ClientSocket.Sendln('HTTP/1.0 200 OK');
            ClientSocket.Sendln('Server: WebApp/1.0 (Win64) by TestAplications');
            ClientSocket.Sendln('Content-Length: ' + IntToStr(Length(TFileRequest.Text)));
            ClientSocket.Sendln('Content-Type: text/html');
            ClientSocket.Sendln('Connection: close');
            ClientSocket.Sendln('');
            ClientSocket.Sendln(TFileRequest.Text);
            //ClientSocket.Close;
            TFileRequest.Clear;
            Exit;
          end
        else
          begin
            if FileExists(GetCurrentDir + '\www\404.html') then
              begin
                TFileRequest.LoadFromFile(GetCurrentDir + '\www\404.html');
                ClientSocket.Sendln('HTTP/1.0 404 Not Found');
                ClientSocket.Sendln('');
                ClientSocket.Sendln(TFileRequest.Text);
                //ClientSocket.Close;
                TFileRequest.Clear;
                Exit;
              end
            else
              begin
                ClientSocket.Sendln('HTTP/1.0 404 Not Found');
                ClientSocket.Sendln('');
                ClientSocket.sendLn('<html><body>Pagina Não Encontrada Embutido</body></html>');
                //ClientSocket.Close;
                Exit;
              end;

          end;


    end;

  TRequestHeader.Free;
  TFileRequest.Free;
end;

// FUNCTIONS

function GetIPAddress():String;
var
  WSAData: TWSAData;
  HostEnt: PHostEnt;
  Name: PAnsiChar;
begin
  WSAStartup(2, WSAData);
  Name := AllocMem(255);
  GetHostName(Name, 255);
  HostEnt := GetHostByName(Name);
  with HostEnt^ do
    Result := Format('%d.%d.%d.%d',[Byte(h_addr^[0]),Byte(h_addr^[1]),Byte(h_addr^[2]),Byte(h_addr^[3])]);
  WSACleanup;
end;

end.
