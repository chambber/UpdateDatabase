program UpdateDatabaseTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  UP.Client in '..\src\UP.Client.pas',
  UP.Database in '..\src\UP.Database.pas',
  UP.Table in '..\src\UP.Table.pas',
  UP.Base in '..\src\UP.Base.pas',
  DUnitTestRunner,
  Test.UP.Table in 'Test.UP.Table.pas';

{R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

