unit UP.Client;

interface

uses
  //rtl
  System.Classes, System.SysUtils,
  //FireDAC
  FireDAC.Comp.Client,
  //UP
  UP.Database, UP.Base;

type
  IUPClient = interface(IInterface)
  ['{CCA81625-D505-46EE-A0C5-90CE07019313}']
    function ExecuteCommand(Command: IUPCommand): IUPResponse;
    function ExecuteQuery(Command: IUPCommand): IUPResponse;
  end;

  TUPClient = class sealed(TInterfacedObject, IUPClient)
  private
    FDatabase: TFDConnection;
  public
    constructor Create(Database: TFDConnection);
    class function New(Database: TFDConnection): IUPClient;
    function ExecuteCommand(Command: IUPCommand): IUPResponse;
    function ExecuteQuery(Command: IUPCommand): IUPResponse;
  end;

implementation

{ TUPClient }

constructor TUPClient.Create(DataBase: TFDConnection);
begin
  inherited Create;
  FDatabase := Database;
end;

function TUPClient.ExecuteCommand(Command: IUPCommand): IUPResponse;
begin
  Result := TUPExecute.New(Command).ExecuteCommand;
end;

function TUPClient.ExecuteQuery(Command: IUPCommand): IUPResponse;
begin
  Result := TUPExecute.New(Command).ExecuteQuery;
end;

class function TUPClient.New(Database: TFDConnection): IUPClient;
begin
  Result := Create(Database);
end;

end.
