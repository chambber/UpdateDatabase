unit UP.Structures;

interface

uses
  //rtl
  System.Classes, System.SysUtils,
  //UP
  UP.Table, UP.Client;

type
  IUPStructures = interface(IInterface)
  ['{F2F12102-6D89-4C0E-A7CA-02E9E3410E8D}']
    function Tables: IUPTables;
  end;

  TUPStructures = class sealed(TInterfacedObject, IUPStructures)
  private
    FClient: IUPClient;
  public
    constructor Create(Client: IUPClient);
    class function New(Client: IUPClient): IUPStructures;
    function Tables: IUPTables;
  end;

implementation

{ TUPStructures }

constructor TUPStructures.Create(Client: IUPClient);
begin
  inherited Create;
  FClient := Client;
end;

class function TUPStructures.New(Client: IUPClient): IUPStructures;
begin
  Result := Create(Client);
end;

function TUPStructures.Tables: IUPTables;
begin
  Result := TUPTables.Create(FClient);
end;

end.
