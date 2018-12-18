unit FunTrataErro;

interface

uses
   DBTables,Classes,db, SysUtils;


const
  // erro de tabelas  parametro %s sempre o nome da tabela
  CT_TabelaFechada      = 'A tabela %s não esta aberta !';
  CT_AberturaTabela     = 'Erro na Abertura da tabela %s !';
  CT_ErroTabelaLeitura  = 'Erro da tabela %s, está em somente leitura';
  CT_ErroEdicaoTabela   = 'Erro na edição da tabela %s ';
  CT_ErroInsertTabela   = 'Erro na inserção da tabela %s ';
  CT_ErroGravacaoTabela = 'Erro na gravação do registro da tabela %s ! ';
  CT_ErroDeletaTabela   = 'Erro na exclusão de registro da tabela %s ';
  // erro de TStrings
  CT_ErroInsercaoLinha = 'Erro de inserção na lista de strings, ultima posição %s, posição de inserção %s ';
  CT_ErroDelecaoLinha =  'Erro de exclusão na lista de strings, ultima posição %s, posição de exclusão %s ';


// tabela
function VerificaRequestLive( Tabela : TDataSet ) : Boolean;
procedure TrataErroTabela( tabela : TDataSet; erro : string; Atividade : integer );
// TStrings
procedure TrataErroTStrings( erro : string; parametros : array of const );


implementation

uses ConstMsg;


{ ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           Erro Tabela
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{********************* verifica somente leitura **************************** }
function VerificaRequestLive( Tabela : TDataSet ) : Boolean;
begin
result := false;
  if (tabela is TQuery) then
    result := ( tabela as TQuery ).RequestLive;
end;

{ ************* verifica o erro da tabela ********************************** }
procedure TrataErroTabela( tabela : TDataSet; erro : string; Atividade : integer  ); //1,2,3- insercao,edicao,exclusao * 4,5,6 open,close, grava
begin
  if Atividade = 4 then
  begin
    if TQuery(Tabela).DatabaseName = '' Then
       raise Exception.Create('Não é possível abrir a tabela '+ tabela.Name +', pois a mesma não possui databasename!!!');

    raise exception.Create('Erro na abertura da tabela ' + TQuery(Tabela).Name);
  end
  else
  if atividade in [ 1, 2, 3 ] then
  begin
    if not Tabela.Active then
      ErroFormato(CT_TabelaFechada, [ tabela.name ] )
      else
         if not VerificaRequestLive(tabela) then
           avisoFormato(CT_ErroTabelaLeitura, [ tabela.name ] )
          else
          begin
            erroFormato(erro, [tabela.name]);
            tabela.close;
          end;
  end
  else
  begin
     erroFormato(erro, [tabela.name]);
     tabela.close;
   end;
end;


{ ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           Erro TStrings
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{ *******************  trata erros dos Tstrings ***************************** }
procedure TrataErroTStrings( erro : string; parametros : array of const );
begin
ErroFormato(erro,parametros);
end;



end.
