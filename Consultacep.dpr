program Consultacep;

uses
  Vcl.Forms,
  uBuscaCep in 'uBuscaCep.pas' {Form1},
  InterfaceEndereco in 'InterfaceEndereco.pas',
  ClassEndereco in 'ClassEndereco.pas',
  Endereco in 'Endereco.pas',
  BuscarEndereco in 'BuscarEndereco.pas',
  Connection in 'Connection.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;

end.
