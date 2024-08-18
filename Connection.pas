unit Connection;

interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Phys.FB, System.SysUtils,FireDAC.DApt;

procedure ConfigurarConexao(out AConnection: TFDConnection);

implementation

procedure ConfigurarConexao(out AConnection: TFDConnection);
begin
  AConnection := TFDConnection.Create(nil);
  try
    AConnection.DriverName := 'FB';
    AConnection.Params.Database := 'C:\databases\Enderecodb.fdb';
    AConnection.Params.UserName := 'sysdba';
    AConnection.Params.Password := 'sysdba';
    AConnection.Params.Add('Server=127.0.0.1');
    AConnection.Params.Add('Port=3050');
    AConnection.LoginPrompt := False;

    AConnection.Connected := True;
  except
    on E: Exception do
      Writeln('Erro ao configurar a conex�o: ', E.Message);
  end;
end;

end.

