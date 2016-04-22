unit UP.Base;

interface

uses
  System.Classes, System.SysUtils;

type
  EUPError = class(Exception);

  IUPCommand = interface(IInterface)
    function Text: string;
  end;

  TUPCommand = class sealed(TInterfacedObject, IUPCommand)
  private
    FCommand: TStrings;
  public
    constructor Create(const Command: string); overload;
    class function New(const Command: string): IUPCommand; overload;
    class function New(const Update, Resource: Integer): IUPCommand; overload;
    destructor Destroy; override;
    function Text: string;
  end;

implementation

{ TUPCommand }

constructor TUPCommand.Create(const Command: string);
begin
  FCommand := TStringList.Create;
  FCommand.Text := Command;
end;
destructor TUPCommand.Destroy;
begin
  FCommand.Free;
  inherited;
end;

class function TUPCommand.New(const Update, Resource: Integer): IUPCommand;
var
  vResource: TStream;
begin
  vResource := TResourceStream.Create(HInstance, Format('update%d_%d', [Update, Resource]), 'RCDATA');
  Result := Create(vResource.ToString);
  vResource.Free;
end;

class function TUPCommand.New(const Command: string): IUPCommand;
begin
  Result := Create(Command);
end;

function TUPCommand.Text: string;
begin
  Result := FCommand.Text;
end;

end.
