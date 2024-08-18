unit uBuscaCep;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, BuscarEndereco, Connection,
  FireDAC.Comp.Client, Endereco, InterfaceEndereco, FireDAC.DApt,FireDAC.Comp.UI,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, Firedac.Stan.Async, ClassEndereco;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    btnCep: TButton;
    Label1: TLabel;
    edLogradouro: TEdit;
    edLocalidade: TEdit;
    edBairro: TEdit;
    edUF: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edComplemento: TEdit;
    Label7: TLabel;
    rdTipoResult: TRadioGroup;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    edCep: TEdit;
    procedure btnCepClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edCepKeyPress(Sender: TObject; var Key: Char);
    procedure edCepExit(Sender: TObject);
  private
    FRESTClient: TRESTClient;
    FRESTRequest: TRESTRequest;
    FRESTResponse: TRESTResponse;
    FConexao: TFDConnection;
    FEndereco: TEnderecoResp;
    FEnderecoBsc: TEnderecoBsc;
  public

  end;

var
  Form1: TForm1;

implementation



{$R *.dfm}

procedure TForm1.btnCepClick(Sender: TObject);
var
  Cep, JSONString: string;
  Tipo: integer;
  Endereco: TEnderecoClass;
begin
  if (edcep.Text <> '') then
  begin
    Cep := StringReplace(edcep.Text, '-', '', [rfReplaceAll]);

     if Length(Cep) <> 8 then
     begin
       MessageDlg('Preencha um CEP válido!',TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK],0);
       exit
     end;

    Endereco := FEnderecobsc.BuscarOuAtualizarcep(edCep.Text, rdTipoResult.ItemIndex);
  end
  else if (edLogradouro.Text <> '') and (edLocalidade.Text <> '') and (eduf.Text <> '') then
  begin
    if Length(edLogradouro.Text) < 3 then
      MessageDlg('Endereço inválido!',TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK],0)
    else if Length(edLocalidade.Text) < 3 then
      MessageDlg('Cidade inválida!',TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK],0)
    else if Length(edUF.Text) <> 2 then
      MessageDlg('Estado inválido!',TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK],0)
    else
      Endereco := FEnderecobsc.BuscarOuAtualizarPorEnderecoCompleto(edLogradouro.Text,edUF.Text,edLocalidade.Text, rdTipoResult.ItemIndex);
  end
  else
    MessageDlg('Preencha o CEP ou o Endereço completo!',TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK],0);

  if Assigned(Endereco) and (Endereco.CEP <> '') then
  begin
    edCep.Text := Endereco.CEP;
    edLogradouro.Text := Endereco.Logradouro;
    edComplemento.Text := Endereco.Complemento;
    edBairro.Text := Endereco.Bairro;
    edLocalidade.Text := Endereco.Localidade;
    edUF.Text := Endereco.UF;
  end;
end;

procedure TForm1.edCepExit(Sender: TObject);
  var
    Cep: string;
begin
  Cep := edCep.Text;
  Cep := StringReplace(Cep, '-', '', [rfReplaceAll]);
  if Length(Cep) = 8 then
    edCep.Text := Format('%s-%s', [Copy(Cep, 1, 5), Copy(Cep, 6, 3)])
end;

procedure TForm1.edCepKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9','-', #8]) then
    Key := #0;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ConfigurarConexao(FConexao);
  FEndereco := TEnderecoResp.Create(FConexao);
  FEnderecoBsc := TEnderecoBsc.Create(FEndereco);
end;


end.
