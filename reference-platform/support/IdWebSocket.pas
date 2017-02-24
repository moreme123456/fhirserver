unit IdWebSocket;

interface

Uses
  SysUtils, Classes,
  IdGlobal, IdComponent, IdTCPConnection, IdContext, IdCustomHTTPServer, IdHashSHA, IdCoderMIME;

Type
  TIdWebSocketOperation = (wsoNoOp, wsoText, wsoBinary, wsoClose);

  TIdWebSocketCommand = record
    op : TIdWebSocketOperation;
    text : String;
    bytes : TIdBytes;
    status : integer;
  end;

  TIdWebSocket = class (TIdComponent)
  private
    FConnection : TIdTCPConnection;
    FRequest: TIdHTTPRequestInfo;
    procedure pong;
  public
    function open(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo) : boolean;
    function IsOpen : boolean;
    function read(wait : boolean) : TIdWebSocketCommand;
    procedure write(s : String);
    procedure close;

    Property Request : TIdHTTPRequestInfo read FRequest;
  end;

implementation

{ TIdWebSocket }

function TIdWebSocket.IsOpen: boolean;
begin
  result := assigned(FConnection.IOHandler);
end;

function TIdWebSocket.open(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo): boolean;
var
  s : String;
  hash : TIdHashSHA1;
  base64 : TIdEncoderMIME;
begin
  FRequest := request;
  if request.RawHeaders.Values['Upgrade'] <> 'websocket' then
    raise Exception.Create('Only web sockets supported on this end-point');

  s := request.RawHeaders.Values['Sec-WebSocket-Key']+'258EAFA5-E914-47DA-95CA-C5AB0DC85B11';

  base64 := TIdEncoderMIME.Create(nil);
  hash := TIdHashSHA1.Create;
  try
    s := base64.EncodeBytes(hash.HashString(s, IndyTextEncoding_ASCII));
  finally
    hash.Free;
    base64.Free;
  end;

  response.ResponseNo := 101;
  response.ResponseText := 'Switching Protocols';
  response.CustomHeaders.AddValue('Upgrade', 'websocket');
  response.Connection := 'Upgrade';
  response.CustomHeaders.AddValue('Sec-WebSocket-Accept', s);
  if (request.rawHeaders.IndexOfName('Sec-WebSocket-Protocol') > -1) then
    response.CustomHeaders.AddValue('Sec-WebSocket-Protocol', 'chat');
  response.WriteHeader;

  FConnection := AContext.Connection;
  result := true;
end;

procedure TIdWebSocket.pong;
var
  b : byte;
begin
  b := $80 + $10; // close
  FConnection.IOHandler.write(b);
  b := 0;
  FConnection.IOHandler.write(b);
end;

function TIdWebSocket.read(wait : boolean) : TIdWebSocketCommand;
var
  h, l : byte;
  fin, msk : boolean;
  op : byte;
  mk : TIdBytes;
  len : cardinal;
  i : integer;
begin
  FillChar(result, sizeof(TIdWebSocketCommand), 0);
  if not wait and not FConnection.IOHandler.CheckForDataOnSource then
    result.op := wsoNoOp
  else
  begin
    h := FConnection.IOHandler.ReadByte;
    fin := (h and $80) > 1;
    if not fin then
      raise Exception.Create('Multiple frames not done yet');
    op := h and $0F;
    l := FConnection.IOHandler.ReadByte;
    msk := (l and $80) > 0;
    len := l and $7F;
    if len = 126 then
      len := FConnection.IOHandler.ReadUInt16
    else if len = 127 then
      len := FConnection.IOHandler.ReadUInt32;
    FConnection.IOHandler.ReadBytes(mk, 4);
    FConnection.IOHandler.ReadBytes(result.bytes, len);
    for i := 0 to length(result.bytes) - 1 do
      result.bytes[i] := result.bytes[i] xor mk[i mod 4];
    case op of
      1: begin
         result.op := wsoText;
         result.text := IndyTextEncoding_UTF8.GetString(result.bytes);
         end;
      2: result.op := wsoText;
      8: result.op := wsoClose;
      9: begin
         pong();
         result := read(wait);
         end;
    else
      raise Exception.Create('Unknown OpCode '+inttostr(op));
    end;
  end;
end;

procedure TIdWebSocket.write(s: String);
var
  b : byte;
  w : word;
  bs : TIDBytes;
begin
  b := $80 + $01; // text frame, last
  FConnection.IOHandler.write(b);
  if (length(s) <= 125) then
  begin
    b := length(s);
    FConnection.IOHandler.write(b);
  end
  else if (length(s) <= $FFFF) then
  begin
    b := 126;
    FConnection.IOHandler.write(b);
    w := length(s);
    FConnection.IOHandler.write(w);
  end
  else
  begin
    b := 127;
    FConnection.IOHandler.write(b);
    FConnection.IOHandler.write(length(s));
  end;

  bs := IndyTextEncoding_UTF8.GetBytes(s);
  FConnection.IOHandler.write(bs);
end;

procedure TIdWebSocket.close;
var
  b : byte;
begin
  b := $80 + $08; // close
  FConnection.IOHandler.write(b);
  b := 0;
  FConnection.IOHandler.write(b);
  FConnection.IOHandler.Close;
end;


end.
