unit InterfaceEndereco;

interface

uses ClassEndereco;

type
  IEndereco = interface
    ['{FA1204A3-6C14-4F53-9B5B-6E3B5B7E8326}']
    procedure Salvar(const AEndereco: TEnderecoClass);
    function BuscarPorCEP(const ACep: string): TEnderecoClass;
    function BuscarPorEndereco(const AEnderecoCompleto,AEstado,ACidade: string): TEnderecoClass;
    procedure Atualizar(const AEndereco: TEnderecoClass);
  end;

implementation

end.
