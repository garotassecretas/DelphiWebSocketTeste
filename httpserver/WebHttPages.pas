unit WebHttPages;

interface

uses
  SysUtils, System.JSON, Winapi.Windows, System.Classes, Winsock, Vcl.StdCtrls, Web.Win.Sockets, RegularExpressions;

var
  isConnected: boolean;

function GetIPAddress(): String;

type
  TWebServer = class
  private
    WebServer: TTcpServer;
  public
   procedure WebServerAccept(Sender:TObject; ClientSocket:TCustomipClient);
   constructor Create();
   procedure WebClose();
  end;

implementation

uses
  Unit1;

constructor TWebServer.Create;
begin
  WebServer := TTcpServer.Create(nil);
  WebServer.LocalPort := HttpServerPort.ToString;
  WebServer.OnAccept := WebServerAccept;
  Webserver.Open;
end;

procedure TWebServer.WebClose;
begin
  Webserver.Close;
  Webserver.Destroy;
end;

procedure TWebServer.WebServerAccept(Sender:TObject; ClientSocket:TCustomipClient);
var
  RawData,Path,Agent,RawAgent:String;
  regexfoundcollection: TMatchCollection;
  regexfound: TMatch;
  regexgrps: TGroupCollection;
  HttpPos,AgentPos:Integer;
  TRequestHeader:TStringList;
  TFileRequest:TStringList;
  FileStream: TMemoryStream;
  TNewHtmlFile, FileExt: String;
  i, j: integer;
begin
  RawData := '';
  TRequestHeader := TStringList.create;
  TFileRequest := TStringList.create;

  while ClientSocket.Connected do
    begin
      RawData := ClientSocket.receiveLn();
      while RawData <> '' do
        begin
          TRequestHeader.Add(RawData);
          RawData := ClientSocket.receiveLn();
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

              regexfoundcollection := TRegEx.Matches(TRequestHeader.Strings[i], '(GET?|POST?)\s?(\/([a-zA-Z0-9._-]+)?)',[roIgnoreCase]);

              regexgrps := regexfoundcollection.Item[0].Groups;
              Path := regexgrps.Item[2].Value;

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
            ClientSocket.sendLn('<!DOCTYPE html><html><meta name="viewport" content="width=device-width, initial-scale=1.0"><head><title>WebSocket Html</title></head><body>TESTE PAGINA INTERNA</br><button id="btnteste">Executar Teste</button><script>');
            ClientSocket.sendLn('const socket = new WebSocket("ws://'+GetIPAddress+':'+WebSocketPort.ToString+'");');
            ClientSocket.sendLn('socket.addEventListener("open", function (event) {	socket.send("Hello Server Interno!"); });');
            ClientSocket.sendLn('socket.addEventListener(''message'', function (event) { console.log(''Message from server "'' + event.data + ''"''); });');
            ClientSocket.sendLn('document.getElementById("btnteste").addEventListener(''click'', function (event) { socket.send(''tstcommand''); });');
            ClientSocket.sendLn('</script></body></html>');
            //ClientSocket.Close;
            Exit;
          end;

        if FileExists(GetCurrentDir + '\www'+ Path) then
          begin
            TFileRequest.LoadFromFile(GetCurrentDir + '\www'+ Path);
            FileExt := ExtractFileExt(Path);
            ClientSocket.Sendln('HTTP/1.0 200 OK');
            ClientSocket.Sendln('Server: WebApp/1.0 (Win64) by TestAplications');

            TNewHtmlFile := stringreplace(TFileRequest.Text, 'WEBIPURLPORT', GetIPAddress+':'+WebSocketPort.ToString , [rfReplaceAll, rfIgnoreCase]);
            if (FileExt = '.css') then
              ClientSocket.Sendln('Content-Type: text/css')
            else if (FileExt = '.js') then
              ClientSocket.Sendln('Content-Type: text/javascript')
            else
              begin
                ClientSocket.Sendln('Content-Length: ' + IntToStr(Length(TNewHtmlFile)));
                ClientSocket.Sendln('Content-Type: text/html');
              end;
            ClientSocket.Sendln('Connection: close');
            ClientSocket.Sendln('');
            ClientSocket.Sendln(TNewHtmlFile);
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
