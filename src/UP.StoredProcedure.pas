unit UP.StoredProcedure;

interface

uses
  //rtl
  System.Classes, System.SysUtils,
  //UP
  UP.Base;

type
  EUPErrorStoredProcedure = class(EUPError);

  IUPStoredProcedure = interface(IInterface)
  ['{D6472E9B-D745-4E36-8068-8852BBB911E0}']
    function Name: string;
  end;

  IUPStoredProcedures = interface(IInterface)
  ['{2FC803E1-43FE-40BB-85E3-F7D94DAE2727}']
    function Get(const StoredProcedure: string): IUPStoredProcedure;
    procedure Delete(const StoredProcedure: string);
    function Add(const StoredProcedure, Command: string): IUPStoredProcedure; overload;
    function Add(const StoredProcedure: string; const Update, Resource: Integer): IUPStoredProcedure; overload;
    function Put(const StoredProcedure, Command: string): IUPStoredProcedure; overload;
    function Put(const StoredProcedure: string; const Update, Resource: Integer): IUPStoredProcedure; overload;
  end;

implementation

end.
