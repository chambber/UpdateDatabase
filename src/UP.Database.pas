unit UP.Database;

interface

uses
  //rtl
  System.Classes, System.SysUtils,
  //FireDAC
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Phys.FB,
  //UP
  UP.Base;

type
  IUPCredentials = interface(IInterface)
  ['{7AFEE91E-A271-42FC-9DFA-FE3659A80685}']
    function Database: string;
    function UserName: string;
    function Password: string;
    function DriverName: string;
    function LoginPrompt: Boolean;
  end;

  IUPDatabase = interface(IInterface)
  ['{720CE7DB-F67F-402D-A8DC-F0696DA0B52F}']
    function Credentials: IUPCredentials;
    function Connection: TFDConnection;
  end;

  IUPResponse = interface(IInterface)
  ['{A577D58D-7AFF-446F-B13A-76FDA24F2F88}']
    function MessageExecute: string;
    function Cursor: TFDMemTable;
  end;

  IUPExecute = interface(IInterface)
  ['{7F4134C1-9CC9-4FB5-AE8D-06A9930B0935}']
    function ExecuteCommand: IUPResponse;
    function ExecuteQuery: IUPResponse;
  end;

  TUPCredentials = class sealed(TInterfacedObject, IUPCredentials)
  private
    FDatabase: string;
    FUserName: string;
    FPassword: string;
    FDriverName: string;
    FLoginPrompt: Boolean;
  public
    constructor Create(const Database, UserName, Password, DriverName: string; LoginPrompt: Boolean);
    class function New(const Database, UserName, Password, DriverName: string; LoginPrompt: Boolean): IUPCredentials; overload;
    class function New(const Database, UserName, Password, DriverName: string): IUPCredentials; overload;
    function Database: string;
    function UserName: string;
    function Password: string;
    function DriverName: string;
    function LoginPrompt: Boolean;
  end;

  TUPDatabase = class sealed(TInterfacedObject, IUPDatabase)
  strict private
    FCredentials: IUPCredentials;
    FConnection: TFDConnection;
  public
    constructor Create(Credentials: IUPCredentials);
    class function New(Credentials: IUPCredentials): IUPDatabase;
    destructor Destroy; override;
    function Credentials: IUPCredentials;
    function Connection: TFDConnection;
  end;

  TUPResponse = class sealed(TInterfacedObject, IUPResponse)
  private
    FMessageExecute: string;
    FCursor: TFDMemTable;
  public
    constructor Create(const MessageExecute: string; Cursor: TFDMemTable);
    class function New(const MessageExecute: string; Cursor: TFDMemTable): IUPResponse; overload;
    class function New(const MessageExecute: string): IUPResponse; overload;
    destructor Destroy; override;
    function MessageExecute: string;
    function Cursor: TFDMemTable;
  end;

  TUPExecute = class sealed(TInterfacedObject, IUPExecute)
  private
    FSender: TUPDatabase;
    FCommand: IUPCommand;
  public
    constructor Create(Command: IUPCommand);
    class function New(Command: IUPCommand): IUPExecute;
    destructor Destroy; override;
    function ExecuteCommand: IUPResponse;
    function ExecuteQuery: IUPResponse;
  end;

var
  FDBConnection: TFDConnection;

implementation

{ TUPResult }

constructor TUPResponse.Create(const MessageExecute: string; Cursor: TFDMemTable);
begin
  inherited Create;
  FMessageExecute := MessageExecute;
  FCursor := Cursor;
end;

function TUPResponse.Cursor: TFDMemTable;
begin
  Result := FCursor;
end;

destructor TUPResponse.Destroy;
begin
  inherited;
end;

function TUPResponse.MessageExecute: string;
begin
  Result := FMessageExecute;
end;

class function TUPResponse.New(const MessageExecute: string): IUPResponse;
begin
  Result := Create(MessageExecute, nil);
end;

class function TUPResponse.New(const MessageExecute: string; Cursor: TFDMemTable): IUPResponse;
begin
  Result := Create(MessageExecute, Cursor);
end;

{ TUPExecuteCommand }

constructor TUPExecute.Create(Command: IUPCommand);
begin
  inherited Create;
  FCommand := Command;
  FSender := TUPDatabase.Create(
    TUPCredentials.New(
      'localhost/3051:E:\Bancos\OS 3776\WSAC.FDB',
      'SYSDBA',
      'masterkey',
      'FB'
    )
  );
end;

destructor TUPExecute.Destroy;
begin
  FSender.Free;
  inherited;
end;

function TUPExecute.ExecuteCommand: IUPResponse;
var
  vMessage: string;
begin
  FSender.Connection.StartTransaction;
  try
    FSender.Connection.ExecSQL(FCommand.Text);
    FSender.Connection.Commit;
    vMessage := 'OK';
  except
    on E: Exception do
    begin
      FSender.Connection.Rollback;
      vMessage := E.Message;
    end;
  end;
  Result := TUPResponse.New(vMessage);
end;

function TUPExecute.ExecuteQuery: IUPResponse;
var
  vMessage: string;
begin
  try
    FSender.Connection.ExecSQL(FCommand.Text);
    vMessage := 'OK';
  except
    on E: Exception do
    begin
      vMessage := E.Message;
    end;
  end;
  Result := TUPResponse.New(vMessage);
end;

class function TUPExecute.New(Command: IUPCommand): IUPExecute;
begin
  Result := Create(Command);
end;

{ TUPCredentials }

constructor TUPCredentials.Create(const Database, UserName, Password, DriverName: string; LoginPrompt: Boolean);
begin
  inherited Create;
  FDatabase := Database;
  FUserName := UserName;
  FPassword := Password;
  FDriverName := DriverName;
  FLoginPrompt := LoginPrompt;
end;

function TUPCredentials.Database: string;
begin
  Result := FDatabase;
end;

function TUPCredentials.DriverName: string;
begin
  Result := FDriverName;
end;

function TUPCredentials.LoginPrompt: Boolean;
begin
  Result := FLoginPrompt;
end;

class function TUPCredentials.New(const Database, UserName, Password, DriverName: string; LoginPrompt: Boolean): IUPCredentials;
begin
  Result := Create(Database, UserName, Password, DriverName, LoginPrompt);
end;

class function TUPCredentials.New(const Database, UserName, Password, DriverName: string): IUPCredentials;
begin
  Result := Create(Database, UserName, Password, DriverName, False);
end;

function TUPCredentials.Password: string;
begin
  Result := FPassword;
end;

function TUPCredentials.UserName: string;
begin
  Result := FUserName;
end;

{ TUPDatabase }

function TUPDatabase.Connection: TFDConnection;
begin
  Result := FConnection;
end;

constructor TUPDatabase.Create(Credentials: IUPCredentials);
begin
  inherited Create;
  FCredentials := Credentials;
  FDBConnection := TFDConnection.Create(nil);
  try
    FDBConnection.LoginPrompt := FCredentials.LoginPrompt;
    FDBConnection.DriverName := FCredentials.DriverName;
    FDBConnection.Params.Database := FCredentials.Database;
    FDBConnection.Params.UserName := FCredentials.UserName;
    FDBConnection.Params.Password := FCredentials.Password;
    FDBConnection.Open;
  except
    on E: Exception do
      raise Exception.Create('Error access database!');
  end;
end;

function TUPDatabase.Credentials: IUPCredentials;
begin
  Result := FCredentials;
end;

destructor TUPDatabase.Destroy;
begin
  FConnection.Free;
  inherited;
end;

class function TUPDatabase.New(Credentials: IUPCredentials): IUPDatabase;
begin
  Result := Create(Credentials);
end;

end.
