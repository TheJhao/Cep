unit Endereco;

interface

uses
  InterfaceEndereco, ClassEndereco, System.SysUtils, System.Classes, FireDAC.Comp.Client;

type
  TEnderecoResp = class(TInterfacedObject, IEndereco)
  private
    FConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);
    procedure Salvar(const AEndereco: TEnderecoClass);
    function BuscarPorCEP(const ACep: string): TEnderecoClass;
    function BuscarPorEndereco(const AEnderecoCompleto,AEstado,ACidade: string): TEnderecoClass;
    procedure Atualizar(const AEndereco: TEnderecoClass);
  end;

implementation

constructor TEnderecoResp.Create(AConnection: TFDConnection);
begin
  FConnection := AConnection;
end;

procedure TEnderecoResp.Salvar(const AEndereco: TEnderecoClass);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'INSERT INTO Enderecos (CEP, Logradouro, Complemento, Bairro, Localidade, UF) ' +
                      'VALUES (:CEP, :Logradouro, :Complemento, :Bairro, :Localidade, :UF)';
    Query.Params.ParamByName('CEP').AsString := AEndereco.CEP;
    Query.Params.ParamByName('Logradouro').AsString := AEndereco.Logradouro;
    Query.Params.ParamByName('Complemento').AsString := AEndereco.Complemento;
    Query.Params.ParamByName('Bairro').AsString := AEndereco.Bairro;
    Query.Params.ParamByName('Localidade').AsString := AEndereco.Localidade;
    Query.Params.ParamByName('UF').AsString := AEndereco.UF;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

function TEnderecoResp.BuscarPorCEP(const ACep: string): TEnderecoClass;
var
  Query: TFDQuery;
  Endereco: TEnderecoClass;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'SELECT * FROM Enderecos WHERE CEP = :CEP';
    Query.Params.ParamByName('CEP').AsString := ACep;
    Query.Open;
    if not Query.IsEmpty then
    begin
      Endereco := TEnderecoClass.Create;
      Endereco.CEP := Query.FieldByName('CEP').AsString;
      Endereco.Logradouro := Query.FieldByName('Logradouro').AsString;
      Endereco.Complemento := Query.FieldByName('Complemento').AsString;
      Endereco.Bairro := Query.FieldByName('Bairro').AsString;
      Endereco.Localidade := Query.FieldByName('Localidade').AsString;
      Endereco.UF := Query.FieldByName('UF').AsString;
      Result := Endereco;
    end
    else
      Result := nil;
  finally
    Query.Free;
  end;
end;

function TEnderecoResp.BuscarPorEndereco(const AEnderecoCompleto, AEstado,
  ACidade: string): TEnderecoClass;
var
  Query: TFDQuery;
  Endereco: TEnderecoClass;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'SELECT * FROM Enderecos WHERE UPPER(logradouro) = UPPER(:logradouro) and UPPER(localidade) = :localidade and UPPER(uf) = :uf';
    Query.Params.ParamByName('logradouro').AsString := UpperCase(AEnderecoCompleto);
    Query.Params.ParamByName('localidade').AsString := UpperCase(ACidade);
    Query.Params.ParamByName('uf').AsString := UpperCase(AEstado);
    Query.Open;
    if not Query.IsEmpty then
    begin
      Endereco := TEnderecoClass.Create;
      Endereco.CEP := Query.FieldByName('CEP').AsString;
      Endereco.Logradouro := Query.FieldByName('Logradouro').AsString;
      Endereco.Complemento := Query.FieldByName('Complemento').AsString;
      Endereco.Bairro := Query.FieldByName('Bairro').AsString;
      Endereco.Localidade := Query.FieldByName('Localidade').AsString;
      Endereco.UF := Query.FieldByName('UF').AsString;
      Result := Endereco;
    end
    else
      Result := nil;
  finally
    Query.Free;
  end;
end;

procedure TEnderecoResp.Atualizar(const AEndereco: TEnderecoClass);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'UPDATE Enderecos SET Logradouro = :Logradouro, Complemento = :Complemento, ' +
                      'Bairro = :Bairro, Localidade = :Localidade, UF = :UF ' +
                      'WHERE CEP = :CEP';
    Query.Params.ParamByName('CEP').AsString := AEndereco.CEP;
    Query.Params.ParamByName('Logradouro').AsString := AEndereco.Logradouro;
    Query.Params.ParamByName('Complemento').AsString := AEndereco.Complemento;
    Query.Params.ParamByName('Bairro').AsString := AEndereco.Bairro;
    Query.Params.ParamByName('Localidade').AsString := AEndereco.Localidade;
    Query.Params.ParamByName('UF').AsString := AEndereco.UF;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

end.

