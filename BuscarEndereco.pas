unit BuscarEndereco;

interface

uses
  InterfaceEndereco, ClassEndereco, System.JSON, System.SysUtils, System.Variants,
  System.Classes, REST.Client,Vcl.Dialogs, Xml.XMLIntf, Xml.XMLDoc, System.UITypes;

type
  TEnderecoBsc = class
  private
    FRepository: IEndereco;
    FRESTClient: TRESTClient;
    FRESTRequest: TRESTRequest;
    FRESTResponse: TRESTResponse;
  public
    constructor Create(ARepository: IEndereco);
    function BuscarOuAtualizarcep(const ACep:string; TipoResult: integer): TEnderecoClass;
    function BuscarOuAtualizarPorEnderecoCompleto(const AEnderecoCompleto,AEstado,ACidade: string; TipoResult:integer): TEnderecoClass;
    function API(const URL: string): string;
    procedure PesquisaAPICEP(CEP:string;const Endereco: TEnderecoClass; TipoResult:integer);
    procedure PesquisaAPIEndereco(const EnderecoCompleto,Estado,Cidade: string; const Endereco: TEnderecoClass; TipoResult:integer);
    procedure ConfiguraREST;
  end;


implementation

const
  ViaCEPURLJson = 'https://viacep.com.br/ws/%s/json/';
  ViaCEPURLXml = 'https://viacep.com.br/ws/%s/xml/';
  ViaCEPURLCompletoJson = 'https://viacep.com.br/ws/%s/%s/%s/json/';
  ViaCEPURLCompletoXml = 'https://viacep.com.br/ws/%s/%s/%s/xml/';

procedure TEnderecoBsc.ConfiguraREST;
begin
  FRESTClient := TRESTClient.Create(nil);
  FRESTRequest := TRESTRequest.Create(nil);
  FRESTResponse := TRESTResponse.Create(nil);
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;
end;

constructor TEnderecoBsc.Create(ARepository: IEndereco);
begin
  FRepository := ARepository;
  ConfiguraREST;
end;

procedure TEnderecoBsc.PesquisaAPICep(CEP: string; const Endereco: TEnderecoClass; TipoResult:integer);
var
  RetornoString: string;
  Retorno: TJSONObject;
  XMLDocument: IXMLDocument;
  Node: IXMLNode;
begin
  if (TipoResult = 0) then
  begin
    RetornoString := API(Format(ViaCEPURLJson, [Cep]));
    if (RetornoString <> '') then
    begin
      Retorno := TJSONObject.ParseJSONValue(RetornoString) as TJSONObject;
      if (Assigned(Retorno.GetValue('erro'))) then
        Retorno := nil;
    end;
    try
      if Assigned(Retorno) then
      begin
        Endereco.CEP := CEP;
        Endereco.Logradouro := Retorno.GetValue('logradouro').Value;
        Endereco.Complemento := Retorno.GetValue('complemento').Value;
        Endereco.Bairro := Retorno.GetValue('bairro').Value;
        Endereco.Localidade := Retorno.GetValue('localidade').Value;
        Endereco.UF := Retorno.GetValue('uf').Value;
      end;
    finally
      Retorno.Free;
    end;
  end
  else
  begin
    RetornoString := API(Format(ViaCEPURLXml, [Cep]));
    XMLDocument := TXMLDocument.Create(nil);
    try
      XMLDocument.LoadFromXML(RetornoString);
      XMLDocument.Active := True;

      Node := XMLDocument.DocumentElement.ChildNodes.FindNode('cep');
      if Assigned(Node) then
        Endereco.CEP := Node.Text;

      Node := XMLDocument.DocumentElement.ChildNodes.FindNode('logradouro');
      if Assigned(Node) then
        Endereco.Logradouro := Node.Text;

      Node := XMLDocument.DocumentElement.ChildNodes.FindNode('complemento');
      if Assigned(Node) then
        Endereco.Complemento := Node.Text;

      Node := XMLDocument.DocumentElement.ChildNodes.FindNode('bairro');
      if Assigned(Node) then
        Endereco.Bairro := Node.Text;

      Node := XMLDocument.DocumentElement.ChildNodes.FindNode('localidade');
      if Assigned(Node) then
        Endereco.Localidade := Node.Text;

      Node := XMLDocument.DocumentElement.ChildNodes.FindNode('uf');
      if Assigned(Node) then
        Endereco.UF := Node.Text;
    finally
      XMLDocument := nil;
    end;
  end;
end;

procedure TEnderecoBsc.PesquisaAPIEndereco(const EnderecoCompleto, Estado,
  Cidade: string; const Endereco: TEnderecoClass; TipoResult: integer);
var
  RetornoString,URL: string;
  Retorno: TJSONObject;
  XMLDocument: IXMLDocument;
  Node: IXMLNode;
  RetornoArray: TJSONArray;
begin
  if (TipoResult = 0) then
  begin
    URL := Format(ViaCEPURLCompletoJson, [Estado, Cidade, EnderecoCompleto]);
    RetornoString := API(URL);
    if (RetornoString <> '') then
    begin
     RetornoArray := TJSONArray.ParseJSONValue(RetornoString) as TJSONArray;
      if Assigned(RetornoArray) and (RetornoArray.Count > 0) then
      begin
        Retorno := RetornoArray.Items[0] as TJSONObject;
        Endereco.CEP := Retorno.GetValue('cep').Value;;
        Endereco.Logradouro := Retorno.GetValue('logradouro').Value;
        Endereco.Complemento := Retorno.GetValue('complemento').Value;
        Endereco.Bairro := Retorno.GetValue('bairro').Value;
        Endereco.Localidade := Retorno.GetValue('localidade').Value;
        Endereco.UF := Retorno.GetValue('uf').Value;
      end;
      RetornoArray.Free;
    end;
  end
  else
  begin
    URL := Format(ViaCEPURLCompletoXml, [Estado, Cidade, EnderecoCompleto]);
    RetornoString := API(URL);
    XMLDocument := TXMLDocument.Create(nil);
    try
      XMLDocument.LoadFromXML(RetornoString);
      XMLDocument.Active := True;

      Node := XMLDocument.DocumentElement.ChildNodes.FindNode('enderecos').ChildNodes.FindNode('endereco');
      if Assigned(Node) then
      begin
        Endereco.CEP := Node.ChildNodes.FindNode('cep').Text;
        Endereco.Logradouro := Node.ChildNodes.FindNode('logradouro').Text;
        Endereco.Complemento := Node.ChildNodes.FindNode('complemento').Text;
        Endereco.Bairro := Node.ChildNodes.FindNode('bairro').Text;
        Endereco.Localidade := Node.ChildNodes.FindNode('localidade').Text;
        Endereco.UF := Node.ChildNodes.FindNode('uf').Text;
      end;
    finally
      XMLDocument := nil;
    end;
  end;
end;

function TEnderecoBsc.BuscarOuAtualizarcep(const ACep:string; TipoResult: integer): TEnderecoClass;
var
  Endereco: TEnderecoClass;
  Escolha:integer;
begin
  Endereco := FRepository.BuscarPorCEP(ACep);
  if Assigned(Endereco) and (Endereco.CEP <> '') then
  begin
    Escolha := MessageDlg('O cep já existe na base de dados. Deseja atualizar as informações?',mtConfirmation, [mbYes, mbNo],0);

    if (Escolha = 6) then
    begin
      Endereco := TEnderecoClass.Create;
      PesquisaAPICep(ACEP,Endereco,TipoResult);
      FRepository.Atualizar(Endereco);
    end;

    Result := Endereco;
  end
  else
  begin
    Endereco := TEnderecoClass.Create;
    PesquisaAPICep(ACEP,Endereco,TipoResult);

    if (Endereco.CEP <> '') and (Endereco.Logradouro <> '') then
      FRepository.Salvar(Endereco)
    else
       MessageDlg('Não foi possível encontrar o endereço!',TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK],0);

    Result := Endereco;
  end;
end;

function TEnderecoBsc.BuscarOuAtualizarPorEnderecoCompleto(const AEnderecoCompleto,AEstado,ACidade: string; TipoResult:integer): TEnderecoClass;
var
  Endereco: TEnderecoClass;
  Escolha:integer;
begin
  Endereco := FRepository.BuscarPorEndereco(AEnderecoCompleto,AEstado,ACidade);
  if Assigned(Endereco) and (Endereco.CEP <> '') then
  begin
    Escolha := MessageDlg('O endereço já existe na base de dados. Deseja atualizar as informações?',mtConfirmation, [mbYes, mbNo],0);

    if (Escolha = 6) then
    begin
      Endereco := TEnderecoClass.Create;
      PesquisaAPIEndereco(AEnderecoCompleto,AEstado,ACidade,Endereco,TipoResult);
      FRepository.Atualizar(Endereco);
    end;

    Result := Endereco;
  end
  else
  begin
    Endereco := TEnderecoClass.Create;
    PesquisaAPIEndereco(AEnderecoCompleto,AEstado,ACidade,Endereco,TipoResult);

    if (Endereco.CEP <> '') and (Endereco.Logradouro <> '') then
      FRepository.Salvar(Endereco)
    else
       MessageDlg('Não foi possível encontrar o endereço!',TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK],0);

    Result := Endereco;
  end;
end;

function TEnderecoBsc.API(const URL: string): string;
begin
  try
    Result := '';
    FRESTClient.BaseURL := URL;
    FRESTRequest.Execute;
    if (FRESTResponse.StatusCode = 200) then
      Result := FRESTResponse.Content;
  except
    on E: Exception do
      Result := '';
  end;
end;


end.
