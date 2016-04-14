unit UP.Base;

interface

uses
  System.Classes, System.SysUtils;

type
  IUPCommand = interface(IInterface)
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromResource(const ResourceName: string);
    procedure LoadFromFile(const FileName: string);
    function Text: string;
  end;

  TUPCommand = class sealed(TInterfacedObject, IUPCommand)
  private
    FCommand: TStrings;
  public
    constructor Create(Command: TStrings);
    class function New(Command: TStrings): IUPCommand; overload;
    class function New: IUPCommand; overload;
    destructor Destroy; override;
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromResource(const ResourceName: string);
    procedure LoadFromFile(const FileName: string);
    function Text: string;
  end;

implementation

{ TUPCommand }

constructor TUPCommand.Create(Command: TStrings);
begin
  FCommand := TStringList.Create;
  if Assigned(Command) then
    FCommand.Text := Command.Text;
end;

destructor TUPCommand.Destroy;
begin
  FCommand.Free;
  inherited;
end;

procedure TUPCommand.LoadFromFile(const FileName: string);
begin
  FCommand.LoadFromFile(FileName);
end;

procedure TUPCommand.LoadFromResource(const ResourceName: string);
var
  vResource: TResourceStream;
begin
  vResource := TResourceStream.Create(HInstance, ResourceName, 'RCDATA');
  try
    FCommand.LoadFromStream(vResource);
  finally
    vResource.Free;
  end;
end;

procedure TUPCommand.LoadFromStream(Stream: TStream);
begin
  FCommand.LoadFromStream(Stream);
end;

class function TUPCommand.New: IUPCommand;
begin
  Result := Create(nil);
end;

class function TUPCommand.New(Command: TStrings): IUPCommand;
begin
  Result := Create(Command);
end;

function TUPCommand.Text: string;
begin
  Result := FCommand.Text;
end;

end.
