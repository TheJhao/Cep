Consulta CEP


Um aplicativo em Delphi 11 Community para consulta e gerenciamento de informações de CEP utilizando padrões de repositório. Este projeto demonstra a utilização da arquitetura de software e patterns como Repository e a integração com APIs para validação e recuperação de dados de endereços.


Arquitetura Utilizada:

Repository Pattern: Utilizado para separar a lógica de acesso a dados da lógica de negócios. Isso permite que o código de acesso a dados seja facilmente substituído ou modificado sem afetar a lógica de negócios.

Componentes e Bibliotecas:

Delphi 11 Community: Ambiente de desenvolvimento integrado (IDE) utilizado para criar o aplicativo.

FireDAC: Biblioteca para acesso e manipulação de bancos de dados, utilizada para a conexão e operações com o Firebird.

REST Client Library: Utilizada para fazer requisições HTTP para APIs externas como ViaCEP.



Como Executar o Aplicativo:

Pré-requisitos
Delphi 11 Community instalado.
Firebird instalado e configurado.
Configuração da Conexão com o Banco de Dados

Abra o arquivo Connection.pas e ajuste os parâmetros de conexão do TFDConnection conforme a configuração do seu banco de dados Firebird.



Compilação e Execução:

Abra o projeto no Delphi 11 Community.
Compile o projeto.
Execute o aplicativo e utilize a interface para consultar e gerenciar informações de CEP.



Funcionalidades:

Consulta por CEP: Permite ao usuário buscar um endereço através de um CEP válido.

Consulta por Endereço Completo: Caso o CEP não esteja disponível, o usuário pode buscar utilizando a combinação de logradouro, localidade e UF.

Atualização de Dados: Se o endereço já estiver armazenado na base de dados, o usuário pode optar por atualizá-lo com as informações mais recentes.

Formatos de Resposta: Suporte tanto para respostas em JSON quanto em XML.
