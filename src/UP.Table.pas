unit UP.Table;

interface

uses
  //rtl
  System.Classes, System.SysUtils,
  //UP
  UP.Base;

type
  IUPTable = interface;

  IUPField = interface(IInterface)
  ['{B621900B-53F4-47B7-BCC5-CA0AEDC8E3B2}']
    function Table: IUPTable;
    function Name: string;
    function Command: IUPCommand;
  end;

  IUPFields = interface(IInterface)
  ['{ED7CCB39-293C-4DAC-9564-03D25DA02565}']
    function Get(const FieldName: string): IUPField;
    procedure Delete(const FieldName: string);
    function Add(const FieldName: string; Command: IUPCommand): IUPField;
  end;

  IUPTable = interface(IInterface)
  ['{9F7E2BE9-D6DB-4833-BB81-79478E7BF1F3}']
    function Name: string;
    function Fields: IUPFields;
    function Get(const TableName: string): IUPTable;
    procedure Delete(const TableName: string);
    function Add(const TableName: string; Command: IUPCommand): IUPTable;
  end;

  TUPField = class sealed(TInterfacedObject, IUPField)
  private
    FTable: IUPTable;
    FName: string;
    FCommand: IUPCommand;
  public
    constructor Create(Table: IUPTable; const Name: string; Command: IUPCommand);
    class function New(Table: IUPTable; const Name: string; Command: IUPCommand): IUPField;
    function Table: IUPTable;
    function Name: string;
    function Command: IUPCommand;
  end;

  TUPFields = class sealed(TInterfacedObject, IUPFields)
  private
    FTable: IUPTable;
  public
    constructor Create(Table: IUPTable);
    class function New(Table: IUPTable): IUPFields;
    function Get(const FieldName: string): IUPField;
    procedure Delete(const FieldName: string);
    function Add(const FieldName: string; Command: IUPCommand): IUPField;
  end;

  TUPTable = class sealed(TInterfacedObject, IUPTable)
  private
    FName: string;
  public
    constructor Create(const Name: string);
    class function New(const Name: string): IUPTable;
    function Name: string;
    function Fields: IUPFields;
    function Get(const TableName: string): IUPTable;
    procedure Delete(const TableName: string);
    function Add(const TableName: string; Command: IUPCommand): IUPTable;
  end;

implementation

{ TUPField }

function TUPField.Command: IUPCommand;
begin
  Result := FCommand;
end;

constructor TUPField.Create(Table: IUPTable; const Name: string; Command: IUPCommand);
begin
  inherited Create;
  FTable := Table;
  FName := Name;
  FCommand := Command;
end;

function TUPField.Name: string;
begin
  Result := FName;
end;

class function TUPField.New(Table: IUPTable; const Name: string; Command: IUPCommand): IUPField;
begin
  Result := Create(Table, Name, Command);
end;

function TUPField.Table: IUPTable;
begin
  Result := FTable;
end;

{ TUPFields }

function TUPFields.Add(const FieldName: string; Command: IUPCommand): IUPField;
begin
{ TODO -oRubens -cImplementation : Implement Add Fields }
end;

constructor TUPFields.Create(Table: IUPTable);
begin
  inherited Create;
  FTable := Table;
end;

procedure TUPFields.Delete(const FieldName: string);
begin
{ TODO -oRubens -cImplementation : Implement Delete Fields }
end;

function TUPFields.Get(const FieldName: string): IUPField;
begin
{ TODO -oRubens -cImplementation : Implement Get Fields }
end;

class function TUPFields.New(Table: IUPTable): IUPFields;
begin
  Result := Create(Table);
end;

{ TUPTable }

function TUPTable.Add(const TableName: string; Command: IUPCommand): IUPTable;
begin
{ TODO -oRubens -cImplementation : Implement Add Table }
end;

constructor TUPTable.Create(const Name: string);
begin
  inherited Create;
  FName := Name;
end;

procedure TUPTable.Delete(const TableName: string);
begin

end;

function TUPTable.Fields: IUPFields;
begin

end;

function TUPTable.Get(const TableName: string): IUPTable;
begin

end;

function TUPTable.Name: string;
begin

end;

class function TUPTable.New(const Name: string): IUPTable;
begin

end;

end.
