unit UP.Table;

interface

uses
  //rtl
  System.Classes, System.SysUtils,
  //UP
  UP.Base, UP.Client, UP.Database;

type
  EUPErrorTable = class(EUPError);
  EUPErrorField = class(EUPError);

  IUPTable = interface;

  IUPField = interface(IInterface)
  ['{B621900B-53F4-47B7-BCC5-CA0AEDC8E3B2}']
    function Table: IUPTable;
    function Name: string;
  end;

  IUPFields = interface(IInterface)
  ['{ED7CCB39-293C-4DAC-9564-03D25DA02565}']
    function Get(const FieldName: string): IUPField;
    procedure Delete(const FieldName: string);
    function Add(const FieldName, Command: string): IUPField; overload;
    function Add(const FieldName: string; const Update, Resource: Integer): IUPField; overload;
  end;

  IUPTable = interface(IInterface)
  ['{9F7E2BE9-D6DB-4833-BB81-79478E7BF1F3}']
    function Name: string;
    function Fields: IUPFields;
  end;

  IUPTables = interface(IInterface)
  ['{9B0F9CB9-74AB-4D26-86BE-FF95FC5C05AD}']
    function Get(const TableName: string): IUPTable;
    procedure Delete(const TableName: string);
    function Add(const TableName, Command: string): IUPTable; overload;
    function Add(const TableName: string; const Update, Resource: Integer): IUPTable; overload;
  end;

  TUPField = class sealed(TInterfacedObject, IUPField)
  private
    FTable: IUPTable;
    FName: string;
  public
    constructor Create(Table: IUPTable; const Name: string);
    class function New(Table: IUPTable; const Name: string): IUPField;
    function Table: IUPTable;
    function Name: string;
  end;

  TUPFields = class sealed(TInterfacedObject, IUPFields)
  private
    FClient: IUPClient;
    FTable: IUPTable;

    function AddField(const FieldName: string; Command: IUPCommand): IUPField;
  public
    constructor Create(Client: IUPClient; Table: IUPTable);
    class function New(Client: IUPClient; Table: IUPTable): IUPFields;
    function Get(const FieldName: string): IUPField;
    procedure Delete(const FieldName: string);
    function Add(const FieldName, Command: string): IUPField; overload;
    function Add(const FieldName: string; const Update, Resource: Integer): IUPField; overload;
  end;

  TUPTable = class sealed(TInterfacedObject, IUPTable)
  private
    FClient: IUPClient;
    FName: string;
  public
    constructor Create(Client: IUPClient; const Name: string);
    class function New(Client: IUPClient; const Name: string): IUPTable;
    function Name: string;
    function Fields: IUPFields;
  end;

  TUPTables = class sealed(TInterfacedObject, IUPTables)
  private
    FClient: IUPClient;

    function AddTable(const TableName: string; Command: IUPCommand): IUPTable;
  public
    constructor Create(Client: IUPClient);
    class function New(Client: IUPClient): IUPTables;
    function Get(const TableName: string): IUPTable;
    procedure Delete(const TableName: string);
    function Add(const TableName, Command: string): IUPTable; overload;
    function Add(const TableName: string; const Update, Resource: Integer): IUPTable; overload;
  end;

implementation

{ TUPField }

constructor TUPField.Create(Table: IUPTable; const Name: string);
begin
  inherited Create;
  FTable := Table;
  FName := Name;
end;

function TUPField.Name: string;
begin
  Result := FName;
end;

class function TUPField.New(Table: IUPTable; const Name: string): IUPField;
begin
  Result := Create(Table, Name);
end;

function TUPField.Table: IUPTable;
begin
  Result := FTable;
end;

{ TUPFields }

function TUPFields.Add(const FieldName, Command: string): IUPField;
begin
  Result := AddField(FieldName, TUPCommand.New(Command));
end;

function TUPFields.Add(const FieldName: string; const Update, Resource: Integer): IUPField;
begin
  Result := AddField(FieldName, TUPCommand.New(Update, Resource));
end;

function TUPFields.AddField(const FieldName: string; Command: IUPCommand): IUPField;
var
  vResponse: IUPResponse;
begin
  vResponse := FClient.ExecuteCommand(Command);
  if vResponse.MessageExecute <> 'OK' then
    raise EUPErrorField.CreateFmt('Add Error: %s', [vResponse.MessageExecute]);
end;

constructor TUPFields.Create(Client: IUPClient; Table: IUPTable);
begin
  inherited Create;
  FTable := Table;
  FClient := Client;
end;

procedure TUPFields.Delete(const FieldName: string);
var
  vResponse: IUPResponse;
const
  FIELD: string = 'ALTER TABLE %s DROP %s';
begin
  vResponse := FClient.ExecuteCommand(
     TUPCommand.New(
       Format(FIELD, [FTable.Name.QuotedString, FieldName.QuotedString])
     )
  );
  if vResponse.MessageExecute <> 'OK' then
    raise EUPErrorField.CreateFmt('Delete Error: %s', [vResponse.MessageExecute]);
end;

function TUPFields.Get(const FieldName: string): IUPField;
var
  vResponse: IUPResponse;
const
  FIELD: string = 'SELECT RDB$FIELD_NAME AS CAMPO FROM RDB$RELATION_FIELDS WHERE RDB$FIELD_NAME = %s AND RDB$RELATION_NAME = %s';
begin
  vResponse := FClient.ExecuteCommand(
    TUPCommand.New(
      Format(FIELD, [FTable.Name.QuotedString, FieldName.QuotedString])
    )
  );
  if vResponse.Cursor.IsEmpty then
    raise EUPErrorField.CreateFmt('Get Error: Field "%s" not found in table "%s"', [FieldName, FTable.Name]);
  Result := TUPField.Create(FTable, FieldName);
end;

class function TUPFields.New(Client: IUPClient; Table: IUPTable): IUPFields;
begin
  Result := Create(Client, Table);
end;

{ TUPTable }

constructor TUPTable.Create(Client: IUPClient; const Name: string);
begin
  inherited Create;
  FName := Name;
  FClient := Client;
end;

function TUPTable.Fields: IUPFields;
begin
  Result := TUPFields.Create(FClient, Self);
end;

function TUPTable.Name: string;
begin
  Result := FName;
end;

class function TUPTable.New(Client: IUPClient; const Name: string): IUPTable;
begin
  Result := Create(Client, Name);
end;

{ TUPTables }

function TUPTables.Add(const TableName, Command: string): IUPTable;
begin
  Result := AddTable(TableName, TUPCommand.New(Command));
end;

function TUPTables.Add(const TableName: string; const Update, Resource: Integer): IUPTable;
begin
  Result := AddTable(TableName, TUPCommand.New(Update, Resource));
end;

function TUPTables.AddTable(const TableName: string; Command: IUPCommand): IUPTable;
var
  vResponse: IUPResponse;
begin
  vResponse := FClient.ExecuteCommand(Command);
  if vResponse.MessageExecute <> 'OK' then
    raise EUPErrorTable.CreateFmt('Add Error: %s', [vResponse.MessageExecute]);
end;

constructor TUPTables.Create(Client: IUPClient);
begin
  inherited Create;
  FClient := Client;
end;

procedure TUPTables.Delete(const TableName: string);
var
  vResponse: IUPResponse;
const
  TABLE: string = 'DROP TABLE %s';
begin
  vResponse := FClient.ExecuteCommand(
     TUPCommand.New(
       Format(TABLE, [TableName.QuotedString])
     )
  );
  if vResponse.MessageExecute <> 'OK' then
    raise EUPErrorTable.CreateFmt('Delete Error: %s', [vResponse.MessageExecute]);
end;

function TUPTables.Get(const TableName: string): IUPTable;
var
  vResponse: IUPResponse;
const
  TABLE: string = 'SELECT RDB$RELATION_NAME AS CAMPO FROM RDB$RELATIONS WHERE RDB$RELATION_NAME = %s';
begin
  vResponse := FClient.ExecuteCommand(
    TUPCommand.New(
      Format(TABLE, [TableName.QuotedString])
    )
  );
  if vResponse.Cursor.IsEmpty then
    raise EUPErrorTable.Create('Get Error: table not found');
  Result := TUPTable.Create(FClient, TableName);
end;

class function TUPTables.New(Client: IUPClient): IUPTables;
begin
  Result := Create(Client);
end;

end.
