{***********************************************************}
{                    Systec Sistemas Ltda                   }
{                                                           }
{  Mensagens Constantes Para todas as aplicações e Funçoes  }
{  Sergio Luis Censi  10/08/98                              }
{***********************************************************}

unit ConstMsg;

interface

uses
  httpapp, Graphics, SysUtils, Controls, Dialogs, classes, stdctrls,Messages,Forms;

const
   ErroMaximo = 0.05;

const
  // mensagens de erros
  CT_AberturaBaseDados = 'ERRO BANCO DADOS - Não foi possível abrir o banco de dados. Problemas no banco de dados ou parametro de conecção inválido( alias ).';  // ocorre quando não foi possivel executar o open na base de dados pelo DataBase.
  CT_SenhaInvalida = 'SENHA INVALIDA - Senha Inválida ou Usuário Incorreto';  // quando o usuário digitou a senha errada ou o usuário
  CT_AbortAbertura = 'ABERTURA - Tentativa de Abortagem Negada!';   //Tentativa de fechar o pedido de senha com ALT+F4
  CT_ConfirmaSenha = 'CONFIRMA SENHA - Senha de confirmação é inválida';  // Na alteração de Senha o usuário não digitou a senha de confirmação correta
  CT_ErroGravacao = 'ERRO GRAVAR - Ocorreu um erro ao gravar este registro!!'; // ocorre quando houver um erro de post;
  CT_ErroMontaData = 'ERRO MONTADATA - Valor da Data Inválida'; // Ocorre quando motar uma data com valore invalidos
  CT_ErroFaltaDataset = 'ERRO DATASET -  Não foi definido nenhum DatSet !!'; // quando um componente não for iniciado com o dataset
  CT_FormNaoVisivel = 'ERRO FORM - O Formulário não está visível para receber o foco!! '; // quando um componente recebe o foco com o seu formulario em visible = false;
  CT_ErroCGC = 'ERRO CGC - O %s é um CGC Inválido, deseja corrigir !!!';  //o valor digitado ao campo cgc é inválido
  CT_ErroCPF = 'ERRO CPF - O %s é um CPF Inválido, deseja corrigir !!!';  //o valor digitado ao campo cpf é inválido
  CT_ErroTipoField = 'ERRO CARREGA COMBO - O Campo definido só pode ser String ou Inteiro'; //ocorre quando carrega o combobox, e o campo é diferente de integer ou string
  CT_ErroCampoString = 'ERRO CAMPO STRING - O campo de retorno não é uma string';
  CT_ErroCampoInteger = 'ERRO CAMPO INTEGER - O campo de retorno não é um inteiro';
  CT_ErroDeletaRegistroPai = 'ERRO DE EXCLUSÃO DE REGISTRO - Não é possível excluir pois esta sendo utilizado por outro registro !!';
  CT_CodigoDuplicado = 'DUPLICAÇÃO DE CÓDIGO - Este código já existe';
  CT_FaixaInvalida = ' FAIXA INVÁLIDA = Este código está fora da faixa de valores permitido a esta filial';
  CT_FimInclusaoClassificacao = 'INCLUSÃO INVÁLIDA  -  Não é permitido incluir mais sub-grupos!'; // quando tentar incluir uma nova classificação e a mascara não permitir;
  CT_DuplicacaoClassificacao = 'DUPLICAÇÃO CLASSIFICAÇÃO - Esta Classificação já existe!';
  CT_DuplicacaoPlanoConta = 'DUPLICAÇÃO PLANO CONTA - Este Código do Plano de Conta já existe!';
  CT_ErroInclusaoProduto = 'ERRO INCLUSÃO - Não é permitido incluir em um Produto!'; // tentativa de inserção de um produto no tree em um produto
  CT_ErroInclusaoServico = 'ERRO INCLUSÃO - Não é permitido incluir em um Serviço!'; // tentativa de inserção de um produto no tree em um produto  
  CT_ErroExclusaoClassificaca = 'ERRO EXCLUSÃO - Este item não pode ser apagado pois possui sub-grupos!'; // na tentativa de excluir uma classificacao ja existente
  CT_ClassificacacaoProdutoInvalida = 'ERRO INSERÇÃO - Não é permitido inserir um produto neste grupo!';
  CT_ClassificacacaoServicoInvalida = 'ERRO INSERÇÃO - Não é permitido inserir um serviço neste grupo!';
  CT_ErroDataPagMaiorVen = 'DATA INVÁLIDA - A Data de vencimento "%s" não pode ser menor que a data de pagamento "%s"!';
  CT_ErroCampoCliente = 'CAMPO CLIENTE - Campo cliente requer um valor';
  CT_ErroCampoVendedor = 'CAMPO VENDEDOR - Campo vendedor requer um valor';
  CT_DataMenorQueAtual = 'DATA INVÁLIDA - A data de vencimento não pode ser menor que a atual'; // erro de data no conta a pagar, data menor que a data atual
  CT_DataMenorBAixa = 'DATA INVÁLIDA - A data de pagamento não pode ser menor que a atual'; // erro de data no conta a pagar, data menor que a data atual
  CT_PathInvalido = 'PATH INVÁLIDO - Não foi possível localizar a imagem, porque o caminho está invalido ';
  CT_ExclusaoNota = 'NOTA FISCAL VINCULADA - Não é permitido excluir uma conta que possua uma Nota Fiscal. Para excluir a conta é preciso estornar a nota antes';
  CT_ExcessoProduto = 'EXCESSO DE PRODUTO - Não é possivel adicionar mais itens na Nota Fiscal, Cadastre uma nova.';
  CT_NaoUltimoNumero = 'OPERAÇÃO INVALIDA - Está Nota Fiscal so poderá ser cancelada porque ja existe outra subsequente.';
  CT_ErroUnidade = 'Esta unidade não é valida, para este produto use apenas as unidades '; // no componente valida unidade verifica  se a unidade é válida e adiciona as unidades validas no final do texto
  CT_ErroFaltaImpressora = 'ERRO IMPRESSORA - Não existe a impressora especificada para a impressão, verifique as configurações gerais do sistema ';
  CT_ErroQuantidadeParcelas = 'A Quantidade de parcelas tem que ser maior que "0" !';
  CT_DuplicatDuplicada = ' DUPLICATA DUPLICADA - Esta duplicata já foi cadastrada!';
  CT_AbortaFechar = 'TENTATIVA ABORTADA!!! Tentativa de fechar o formulário inválida...';
  CT_ValorQdadeNulo = 'VALOR NULO - O valor ou quantidade do produto esta vazia. ';
  CT_FechamentoEstoqueMesAnterior = 'FECHAMENTO ESTOQUE - Não poderá ser efetuado o Fechamento de Estoque deste mês, pois o mês anterior ainda não foi Fechado.';
  CT_FechamentoEstoqueMes = 'FECHAMENTO ESTOQUE - Não poderá ser efetuado o Fechamento de Estoque deste mês, o mesmo ja foi fechado.';
  CT_FechamentoEstoqueMesProximo = 'FECHAMENTO ESTOQUE - Não poderá ser Deletado o Fechamento de Estoque, pois o proxímo mês já foi Fechado.';
  CT_AlteraDataSistema = 'ALTERA DATA - Você deseja alterar a data do sistema para %s';
  CT_BancoContaVinculada = 'CONTA VINCULADA - Está conta está vinvulada a um  título a pagar ou receber, você so pode alterar ou estornar através dos títulos.';
  CT_CancelaLancamentoBancario = 'CANCELA LANCAMENTO BANCARIO - Tem certeza que deseja cancelar este lancamento ?';
  CT_BancoContaConciliada = 'CONTA CONCILIADA - Está conta está concialida, não pode ser alterada nem cancelada.';
  CT_ErroConta = 'ERRO GERANDO CONTA - Houve um erro ao tentar gerar esta conta, o processo será abortado e a conta não será gerada.';
  CT_ErroContaDespesa = 'ERRO GERANDO DESPESA - Houve um erro ao tentar gerar a despesa desta conta, o processo será abortado e a despesa não será gerada.';
  CT_DescontoMaiorNota = 'DESCONTO MAIOR NOTA -  O desconto concedido e maior ou igual ao total dos produtos da nota fiscal.';
  CT_ExcluiConta = 'EXCLUIR CONTA - Esta operação ira excluir a conta e todos os seus títulos, você deseja continuar ? ';
  CT_NaoExcluiPossuiTEF = 'TEF - Está operação não pode ser concluida, pois foi gerada através da solução TEF Discado quee não está cancelada, você deve antes cancelar a conta TEF.!';
  CT_TEFCancelado = 'TEF CANCELADO - Ocorreu algum tipo de problema com a impressora fiscal, a transação  TEF foi cancelada.';
  CT_CancelouCancelamento = 'TEF CANCELADO - Está operação foi cancelada.';
  CT_TempoEstourado = 'TEF TEMPO ESTOURADO - O tempo de impressão estourou, será feita uma reimpressão do cupom TEF.';
  CT_ExcluiTitulos  = 'EXCLUIR TITULO - Esta operação ira excluir o título selecionado, você deseja continuar ? ';
  CT_CancelarTitulo  = 'CANCELAR TITULO - Esta operação ira cancelar o título selecionado, você deseja continuar ? ';
  CT_EstornarTitulo  = 'ESTORNAR TITULO - Esta operação ira estornar o título selecionado, você deseja continuar ? ';
  CT_EstornarCancelamento  = 'ESTORNAR CANCELAMENTO - Esta operação ira estornar o cancelamento do título selecionado, você deseja continuar ? ';
  CT_ContaPagaCancelada = 'CONTA PAGA/CANCELADA - Esta operação não pode ser executada, pois a conta esta paga ou cancelada!';
  CT_ImpressoraFiscalFechada = 'IMPRESSORA FISCAL FECHADA -  A Impressora de cupom fiscal não está ligada para a abertura da gaveta.';
  CT_AlteraVendedor = 'ALTERAR VENDEDOR - Tem Certeza que deseja alterar o vendedor desta comissão ?';
  Ct_faltaOpeEstoque = 'FAlTA OPERAÇÃO DE ESTOQUE - Você deve informar as operações de estoque.';
  CT_DiaInvalido = 'DIA INVALIDO - Dia Inválido.';

  CT_FaltaCFGOpeEstoqueECF = 'CONFIGURAÇÕES DE SISTEMA - Configure a opereração de estoque para o ECF na Configuração de Sistema.';
  CT_FaltaCFGOpeCaixaRC = 'CONFIGURAÇÕES DE SISTEMA - Configure a opereração padrão a receber para o caixa na Configuração de Sistema.';
  CT_FaltaCFGFiscalECF = 'CONFIGURAÇÕES DE SISTEMA - Falta configuração do ECF na Configuração de Sistema.';
  CT_FaltaCFGFinanceiro = 'CONFIGURAÇÕES DE SISTEMA - Falta configuração da situação padrão na Configuração de Sistema / Configurações Financeira.';
  CT_CupomVinculado = 'CUPOM VINCULADO -  Não é possivel cancelar o ultimo cupom porque o mesmo possui cupom vinvulado, emita um nota de entrada para o cancelamento.';

  CT_EXTORNAR = 'Tem certeza que deseja extornar o %s ?';
  CT_CANCELAR = 'Tem certeza que deseja cancelar o %s ?';
  CT_ORCAMENTOESGOTADO = 'ORÇAMENTO ESGOTADO!!! Não é possível gerar uma nota fiscal a partir deste %s, pois não existe mais produtos a serem entregues ou o %s foi cancelado...';
  CT_NAOEXISTENOTA = 'NÃO EXISTE NOTA - Não existe nota associada a este orçamento.';
  CT_POSSUIPARCIAL = 'POSSUI PARCIAL - Esta operação não poderá ser efetuada pois possui nota parcial, efetue uma alteração.';

  // mensagens de sucesso
  CT_SenhaAlterada = 'SENHA ALTERADA - A Senha foi alterada com sucesso';  //Quando a senha foi alterada
  CT_ImportacaoCompleta = 'OPERAÇÃO COMPLETADA - Sua importação foi efetuada com sucesso';  //Quando for efetuada uma importação de dados
  CT_NaturezaErrada = ' NATUREZA INCORRETA - Este cliente não é aceito com esta natureza, altere a natureza.';
  CT_DataMaiorFechamento = ' DATA INVALIDA - O mês de fechamento não poder ser maior que o ultimo mês fechado + 1.';
  CT_DataMenorFechamento = ' DATA INVALIDA - O mês de fechamento não poder ser menor que o ultimo mês fechado.';
  CT_MesSemMovimento = 'PERIODO INVALIDO - O início de fechamento é inválido, sendo que o primeiro movimento ocorreu em %s .';

  // mensagens de confirmação
  CT_DeletaRegistro = 'DELETAR REGISTRO - Deseja realmente excluir o registro " ';  // confirmação de exclusão de registro
  CT_DeletarItem = 'DELETAR ITEM - Deseja realmente deletar este item ';
  CT_ErroGravacaoCancela = 'ERRO GRAVACAO - Erro de Gravação, por duplicação de registro ou por algum outro problema interno, deseja cancelar operação ?';  // quando o post der erro
  CT_AtualizaMes = 'ATUALIZAR DESPESAS FIXAS - Virada de mês, você deseja atualizar agora sua despesas fixas ?';
  CT_NaoAFotoAssociado = 'SEM FOTO - Não há foto associado a esta seleção ';
  CT_FaltaEstoque = 'SEM ESTOQUE - Este Produto não possui estoque suficiente. Deseja continuar, sendo que o estoque atual é de '; //na nota fiscal;
  CT_FaltaEstoueTranca = 'SEM ESTOQUE - Este Produto não possui estoque suficiente. Deseja cancelar a operaçao, sendo que o estoque atual é de '; //na nota fiscal;
  CT_NotaJaImpressa = 'NOTA JÁ IMPRESSA - A Nota Fiscal nº %d já foi impressa deseja imprimí-la novamente?';
  CT_PedidoJaImpresso = 'PEDIDO JÁ IMPRESSO - O Pedido nº %d já foi impresso. Deseja imprimí-lo novamente?';
  CT_NotaJaCancelada = 'NOTA JÁ CANCELADA - A Nota Fiscal nº %d já foi cancelada !!';
  CT_NotaJaDevolvida = 'NOTA JÁ DEVOLVIDA - A Nota Fiscal nº %d já foi devolvida !!';
  CT_AtualizarMoedaDia = 'ATUALIZAR MOEDA - Você deseja atualizar as moedas de hoje!';
  CT_ImprimirReserva = 'IMPRIMIR RESERVA - Você deseja imprimir a reserva ? ';
  CT_SemEstoqueTranca = 'SEM ESTOQUE - Este Produto não possui estoque suficiente. Seu estoque atual é de ';
  CT_KitQdadeNula = 'QUANTIDADE NULA - Existe kit com quantidades zerada.';
    // ecf
  CT_ReducaoZ = 'REDUÇÃO Z - Deseja realmente emitir a redução Z do dia %s !';
  CT_LeituraX = 'REDUÇÃO X - Deseja realmente emitir a redução X do dia %s !';
 CT_AlicotaNaoCadastradaECF = 'ALICOTA FALTANTE - A alicota %s não esta cadastrada na imrpessora de ECF, cadastre em configurações de sistema, para esta venda será usado uma alicota padrão.';
 CT_AlicotaNaoCadastradaNF = 'ALICOTA FALTANTE - A alicota do estado %s não esta cadastrada na tabela de icms, para esta venda será usado uma alicota padrão.';
 CT_EstornoComissao = 'ESTORNO COMISSÃO - A comissão desta conta ja foi paga, deseja continuar o estorno da conta, sendo que a comissão não será estornada!';
 CT_CancelaComissao = 'CANCELA COMISSÃO - A comissão desta conta ja foi paga, deseja continuar o cancelamento da conta, sendo que a comissão não será cancelada!';
 CT_CanExcluiCP = 'CANCELA EXCLUI CONTA - Este título não pode ser excluido nem cancelado por que ja esta pago!';
 CT_ExcluidaConta = 'CONTA EXCLUÍDA - A conta foi excluída pois não possuia mais parcelas.';
 CT_CanExcluiComissao = 'EXCLUI COMISSÃO - A comissão deste título ja foi paga, deseja continuar a exclusão, sendo que a comissão não será cancelada!';
 CT_ComissaoPaga = 'COMISSÃO Paga - Esta conta possui comissão paga, você deve antes estornar a comissão!';
 CT_TodaParcelasPagas = 'PARCELAS PAGAS - Todas as parcelas ja foram pagas.';
 CT_BaixaBancario = 'MOVIMENTO BANCÁRIO - Deseja lançar o movimento bancário deste título ?';
 CT_ValorMaiorSaldoCaixa = 'VALOR INVÁLIDO - O valor é maior que o saldo atual do caixa !!!';
 CT_Titulo_Pago = 'TÍTULO VINCULADO - O título a receber vinculado a este adicional já foi pago.';
 CT_Cassificacao_Vazia = 'CLASSIFICAÇÃO SEM PRODUTOS - Não existem produtos para esta classificação.';
 CT_Drivers_Nao_Instalados = 'DRIVERS DE IMPRESSÃO NÃO INSTALADOS - Não existem drivers de impressão instalados.';
 CT_Cheque_Impresso = 'IMPRESSÃO CORRETA - O Documento foi impresso corretamente? Efetuar Baixas?';
 CT_Caixa_Desativado = 'CAIXA INCORRETO - caixa ativo não esta aberto e será desativado.';
 CT_Sem_Parcial_Aberto = 'Não existe caixa para lançamento.';
 CT_Titulo_Nao_Encontrado = 'Título não encontrado.';
 CT_Titulo_Sem_Parcelas = 'Este título não possui parcelas para baixa.';
 CT_Valor_Invalido = 'Valor Inválido.';
 CT_Caixa_Vinculado = 'LANÇAMENTO DE CAIXA VINCULADO - Este título possui um lançamento de caixa vinculado.';
 CT_Documento_Ja_Cadastrado = 'DOCUMENTO JÁ CADASTRADO - Este número de documento já existe.';
 CT_CancelouTransacaoTFE = 'CANCELAMENTO TEF - Não foi possivel completar a operação, por cancelamento da transação ou problemas com a operadora, escolha outra forma de pagamento ou outra operadora.';
 CT_CancelouCancelamentoTFE = 'CANCELAMENTO TEF - Não foi possivel completar a operação, por cancelamento da transação ou problemas com a operadora.';

  // menagens de informação
  CT_FaltaCaixa = 'FALTA CAIXA - Não foi definido nenhum caixa pardão para esta máquina, configure esta opção no módulo de Configurações de Sistema.';
  CT_CaixaGeralJaCriado = 'CAIXA JÁ FOI CRIADO PARA ESTA DATA - Um caixa geral não pode ser aberto duas vezes no mesmo dia.';
  CT_CaixaJaAberto = 'CAIXA JÁ ESTA ABERTO - Este caixa não pode ser aberto novamente!';
  CT_PArcialJaAberto = 'PARCIAL JÁ ESTA ABERTO - Este caixa ja possui uma parcial aberta!';
  CT_SemCaixaGeral = 'NÃO EXISTE CAIXA ABERTO - Não existe caixa geral aberto!';
  CT_CaixaDataInvalida = 'DATA ABERTURA INVÁLIDA - Este caixa não pode ser aberto nesta data, pois existem caixas com data de abertura superior a esta.';
  CT_CaixaParcialDataInvalida = 'DATA ABERTURA INVÁLIDA - Este caixa parcial não pode ser aberto nesta data, pois o caixa está com data de abertura inferior.';
  CT_ItemDataInvalida = 'DATA ABERTURA INVÁLIDA - O caixa está com data de abertura inferior.';
  CT_CaixaJaFechado = 'CAIXA FECHADO OU NÃO ABERTO - Este caixa está fechado ou não foi aberto ainda!';
  CT_ParcialAberto = 'PARCIAL ABERTO - Existe parcial de caixa aberto, feche a parcial antes!';
  CT_FechaCaixaProblema = 'CAIXA COM PROBLEMA = Deseja realmente fechar este caixa com os valores incorretos ? ';
  CT_CaixaAtivo = 'SEM CAIXA ATIVO - Não existe caixa ativo para lançamentos.';
  CT_ParcialGeralAberto = 'ERRO REABERTURA - O Caixa já está aberto!';
  CT_CaixaJaFechadoData = 'CAIXA JÁ FECHADO NA DATA - Este caixa não pode ser reaberto nesta data.';
  CT_ERROCLIENTEDEVOLUCAO =  'ERRO CLIENTE - Não existe nenhum cliente de devolução na configuração de sistema.';
  CT_NotaFaltante = 'FALTA NOTA - Não foi definido nenhuma nota fiscal pardão para esta máquina, configure esta opção no módulo de Configurações de Sistema.';

  CT_UsuarioSemAtividade = 'USUÁRIO SEM ATIVIDADE - Usuário fora de atividade, para poder entrar no sistema peça ao seu administrador para alterar sua situação!';
  CT_UsuarioOutraFilial = 'USUÁRIO VISITANTE - Este usuário não pertence a esta filial !!';
  CT_ProdutoJaEstourado = 'PRODUTO ESTOURADO - Este produto já está estourado!';
  CT_NaoExisteModelo = 'MODELO NULO - Não existe modelo para alteração!';
  CT_DuplicacaoChave = 'CÓDIGO DUPLICADO - Este código já existe!';
  CT_CodigoNaoCadastrado='CÓDIGO NÃO EXISTE - Este código não existe no cadastro!';
  CT_NaoExisteGrupoUSuarios = 'FILIAL SEM GRUPO - Esta filial não possui grupo para habilitar permissões do Sistema!';
  CT_PermissaoNegada = 'PERMISSÃO NEGADA - Você não tem permissão para acessar este formulário, consulte o administrador do Sistema!';
  CT_FimNumerosFaixa = 'FIM DE FAIXA - Não é possivel gerar um novo código, pois estourou a faixa para este cadastro, procure o administrador do Sistema para liberar valores de código para este cadastro!';
  CT_FilialSemMascara = 'FALTA MÁSCARA - Não foi definida nenhuma máscara para a classificação de produtos desta filial, configure a máscara em configurações Gerais! '; // não foi defenido nenhuma picture para a classificacao de produtos
  CT_ClassificacaoDados = 'CLASSIFICAÇÃO COM DADOS - Você não pode alterar a máscara porque a tabela de classificações possui dados!';
  CT_NomeTabela = 'ERRO TABELA - Não existe o nome da tabela, ou esta errada!'; // ocorre na unidade conversão de indice kg,m,mm,cm
  CT_FaltaIndice = 'NÃO EXISTE ÍNDICE - Não foi cadastrado o índice de conversão para esta operação ';
  CT_TipoVariant = 'TIPO VARIANT - O tipo de variante não é compatível';
  CT_ValorDiferente = 'VALOR DIFERENTE - O somatório das parcelas não é igual ao total da nota ';
  CT_ValorDiferenteCheques = 'VALOR DIFERENTE - O somatório dos valores não é igual ao total da a pagar ';
  CT_VerificaCapaLote = 'VERIFICAR CAPA LOTE - Favor conferir e verificar a capa de lote ';
  CT_ErroMaximoTolerado = 'ERRO MÁXIMO - O erro máximo tolerado é de ';   //ocorre na verificacao no cadastro das parcelas do contas a pagar.
  CT_CodigojaUtilizado = 'CÓDIGO JÁ UTILIZADO - O Código acabou de ser usado por um outro usuário da rede, o novo código será ';
  CT_ProdutoNotaRepetido = 'PRODUTO REPETIDO - Este produto já existe na Nota Fiscal';
  CT_FaltaDadosNroNota = 'FALTA DE DADOS - Dados do Corpo da Nota Incompletos ';
  CT_ServicoRepetido = 'SERVIÇO REPETIDO - A Nota Fiscal já possui este serviço.';
  CT_CodServicoRepetido = 'SERVIÇO REPETIDO - Já existe um serviço com esta código.';
  CT_ValorNotaNulo = 'VALOR NOTA NULO - O Valor da Nota Fiscal não pode ser nula! ';
  CT_NaoPossuiNota = 'NÃO POSSUI NOTA - Esta conta não possui nota fiscal cadastrada.';
  CT_FornecedorProdutoRepetido = 'FORNECEDOR REPETIDO - Este Fornecedor já foi informado neste produto';
  CT_NaoFoiCriadoParcelaPArcial = 'NÃO FOI CRIADA PARCELA - Não foi criada a parcela parcial';
  CT_EstoqueProdutoMinimo = 'ESTOQUE MÍNIMO - A quantidade de produtos em estoque está em sua quantidade mínima';
  CT_EstoquePedido = 'ESTOQUE PEDIDO - A quantidade de produtos em estoque está em sua quantidade de pedido ';
  CT_ProdutoPontoPedido = 'PONTO PEDIDO - Este produto está em ponto de pedido.';
  CT_FaltaProduto = 'FALTA PRODUTO - Não existe a quantidade suficiente do produto em estoque';
  CT_ProdutoJaEstaNoOrcamento = 'PRODUTO DUPLICADO - Produto já existe na cotação';
  CT_OrcamentoSemProduto = 'COTAÇÃO SEM PRODUTO - Não é possível realizar a operação pois a cotação não possui nenhum produto associado';
  CT_CondicaoPagtoNulo = 'CONDIÇÃO DE PAGAMENTO NULO - Não é possível efetuar a operação porque a Condição de Pagamento está nula !';
  CT_DescontoInvalido = 'DESCONTO INVÁLIDO - O desconto concedido ao produto e superior ao permitido, o desconto maximo e de %s, mudar desconto?';
  CT_ExclusaoMovBancario = 'EXCLUSAO MOVIMENTO BANCÁRIO - Não podera ser excluido o movimento bancário, este já esta conciliado!';
  CT_ImpressoraInvalida = 'IMPRESSORA INVALIDA -  Impressora configurada no sistema inválida ou não encontrada!!!';
  CT_AdicionaAtividade = 'ADICIONA FORA DE ATIVIDADE - Você deseja adicionar os produtos fora de atividade ? ';
  CT_AlteraTabelaPreco = 'ATENÇÃO - ALTERAÇÃO NA TABELA DE PRECO !!! Você tem certeza que deseja alterar os valores da tabela de preço, sendo que não será possivel retornar ao estado anterior?';
  CT_RegravarBarra = 'REGRAVAR BARRA - Você tem certeza que deseja regravar o Código de Barra %s ';
  CT_InserirProdutoTodaFilial = 'TODAS FILIAIS - Deseja inserir este produto para todas as filiais da empresa atual.';
  CT_MemoriaFluxo =  'SEM MEMÓRIA - Memória insuficiente, Feche alguns Fluxo!';
  CT_FluxoFimNivel = 'FIM DE NÍVEL - Não existe mais nenhum nível com dados!';
  CT_ParcelaPaga = 'EXISTE PARCELA PAGA - Esta operação não pode ser executada porque possui parelas pagas. ';
  CT_BaixaInvalida = 'BAIXA INVALIDA - Esta conta não foi baixada por erro interno.';

  //ICMS
  CT_ErroICMS = 'ERRO ICMS - Não foi possível localizar o ICMS por falta de cadastro';
  // natureza de operacao
  CT_NaturezaInvalida = 'ERRO NATUREZA DE OPERAÇÃO - Natureza de Operação Inválida ';  // quando a natureza de operação é invalida
  CT_DADOSINCOMPLETOS = 'DADOS INCOMPLETOS - Campos em branco'; // quando no estouro de mat pri ou servico faltar a unidade, quantidade ou valores;
  CT_NotaRepetida = 'NOTA CADASTRADA - A Nota fiscal de número %d e série %s já foi cadastrada, o próximo número será %d .';
  CT_NotaRepetidaNroManual = 'NOTA CADASTRADA - A Nota fiscal de número %d e série %s já foi cadastrada ';
  CT_NroNotaSerieNula = 'VALOR INVÁLIDO - O Número ou a série da Nota Fiscal esta em branco ';
  CT_SerieInvalida = 'SERIE INVALIDA - Este número de série não é válida, cadastre-a em configurações de sistema.';
  CT_ImpressoraCondensada = 'IMPRESSORA CONDENSADA - Verifique se a configuração da Fonte da Impressora está em condensado.';
  CT_NotaJaImpressaExclusao = 'NOTA JÁ IMPRESSA = A Nota Fiscal de número %s já está impressa, não pode ser excluída, esta deverá ser cancelada.';
  CT_DeletarNota = 'DELETAR NOTA - Deseja realmente excluir a nota nr. %s !!!';
  CT_CancelarNota = 'CANCELAR NOTA - Deseja realmente cancelar a nota nr. %s !!!';
  CT_DevolucaoNota = 'DEVOLUÇÃO NOTA - Deseja realmente dar entrada de devolução da nota nr. %s !!!';
  CT_MoedasVazias = ' MOEDAS VAZIAS - As Moeda(s) %s de hoje esta(ão) com valores zerados, isto afetará os cálculos realizados a seguir! ';
  CT_DataMoedaDifAtual = 'DATA DIFERENTE - A Data do sistema está diferente da data atual das moedas, você deve atualizar as moedas atuais, ou verificar a data do computador !';
  CT_MoedaVazia = 'MOEDAS VAZIAS - A Moeda  %s está sem cotação!';
  CT_ParcelaAntVAzia = 'PARCELA ANTERIOR EM ABERTO -  A parcela anterior não está quitada, baixe primeiro a anterior!';
  CT_ParcelaPosPaga = 'PARCELA POSTERIOR PAGA -  Esta parcela não pode ser alterada, estorne primeiro a posterior.';  
  CT_EstonoPacialInvalida = 'PARCELA POSSUI PARCIAL - Esta parcela possui mais de um lançamento parcial, estorne o penúltimo lançamento!';
  CT_AutorizacaoMoedaBase = 'Autorização Máxima de alteração do Sistema, somente para suporte autorizado';
  CT_DiretorioInvalidoECF = 'PASTA INVÁLIDA - Não foi possivel localizar o a pasta %s !';
  CT_DataDifECF = 'DATA DIFERENTE DO ECF - Data da impressora do ECF está diferente da data do sistema !';
  CT_KitConversaoMoeda = 'MUDANÇA DE MOEDA - Não é possivel alterar a moeda de um kit ou de seus produtos que o compõe !';
  CT_PortaVazia = 'LOCAL DE IMPRESSAO VAZIO - Não foi definido nenhum local de impressão para esta operação, configure a impressora no sistema.';
//  CT_NotaFiscalJaImpressa = 'NOTA IMPRESSA - Você deseja escluir a conta sendo que a Nota Fiscal não será excluida, nem cancelada por que ja foi impressa ? ';
type
  Uf = array[1..27] of string;
const
  // Estado para carregar no combo UF
  CT_UF : UF = ('AC','AL','AM','AP','BA','CE','DF','ES','GO','MA','MG','MS','MT','PA','PB','PE','PI','PR','RJ','RN','RO','RR','RS','SC','SE','SP','TO');

//envio Mensagens
procedure erro( texto : string);
procedure erroFormato( texto : string; adicional : array of Const);
procedure aviso( texto : string );
procedure AvisoFormato( texto : string; adicional : array of Const);
procedure Informacao( texto : string );
procedure InformacaoFormato( texto : string; adicional : array of Const);
function Confirmacao ( texto : string ) : boolean;
function ConfirmacaoFormato( texto : string; adicional : array of Const) : Boolean;
function Entrada(titulo : string; Texto : string; var retorno : string; senha : boolean; CorCaixa : Tcolor; CorFundo : Tcolor) : Boolean;
function EntradaNumero(titulo : string; Texto : string; var retorno : string; senha : boolean; CorCaixa : Tcolor; CorFundo : Tcolor; UsarMoeda : Boolean) : Boolean;
function EntraData(Titulo : String; Texto : string; var Data : TDateTime ) : Boolean;


implementation

uses
  Entrada, AEntraData;
{******************************************************************************}

{ mensagen de erro }
procedure erro( texto : string);
begin
   beep;
   MessageDlg(Texto,mterror,[mbOk],0);
end;

procedure erroFormato( texto : string; adicional : array of Const);
begin
   beep;
   MessageDlg(Format(Texto,adicional) ,mterror,[mbOk],0);
end;

{******************************************************************************}

{ mensagen de aviso }
procedure aviso( texto : string);
begin
   beep;
   MessageDlg(Texto,mtWarning,[mbOk],0);
end;

procedure AvisoFormato( texto : string; adicional : array of Const);
begin
   beep;
   MessageDlg(Format(Texto,adicional) ,mtWarning,[mbOk],0);
end;

{******************************************************************************}

{ mensagen de informacao }
procedure Informacao( texto : string);
begin
   beep;
   MessageDlg(Texto,mtInformation,[mbOk],0);
end;

procedure InformacaoFormato( texto : string; adicional : array of Const);
begin
   beep;
   MessageDlg(Format(Texto,adicional) ,mtInformation,[mbOk],0);
end;

{******************************************************************************}

{ mensagen de confirmacao }
function Confirmacao( texto : string) : Boolean;
begin
   result := false;
   beep;
  if MessageDlg(Texto, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    result := true;
end;

function ConfirmacaoFormato( texto : string; adicional : array of Const) : Boolean;
begin
   result := false;
   beep;
   if MessageDlg(Format(Texto,adicional) ,mtConfirmation,[mbYes, mbNo],0) = mrYes  then
      result := true;
end;

{******************************************************************************}
function entrada(titulo : string; Texto : string; var retorno : string; senha : boolean; CorCaixa : Tcolor; CorFundo : Tcolor) : Boolean;
var
  Form : TFEntrada;
begin
  Form := TFEntrada.Create(application);
  form.Caixa.Color := CorCaixa;
  form.Color := CorFundo;
  Form.Texto.Caption := texto;
  Form.Caixa.Text := retorno;
  Form.Caption := Titulo;
  if senha then
  begin
     form.Caixa.PasswordChar := '*';
     form.Caixa.CharCase := ecUpperCase;
  end;
  result := form.Executa(retorno);
end;


function EntraData(Titulo : String; Texto : string; var Data : TDateTime ) : Boolean;
begin
result := false;
FEntraData := TFEntraData.Create(application);
FEntraData.Caption := Titulo;
FEntraData.Textodata.Caption := texto;
FEntraData.CaixaData.Date := data;
if FEntraData.Executa(data) then
 result := true;
end;


function EntradaNumero(titulo : string; Texto : string; var retorno : string; senha : boolean; CorCaixa : Tcolor; CorFundo : Tcolor; UsarMoeda : Boolean) : Boolean;
var
  Form : TFEntrada;
begin
  Form := TFEntrada.Create(application);
  form.Caixa.Color := CorCaixa;
  form.Color := CorFundo;
  Form.Texto.Caption := texto;
  try
    Form.Numero.AValor := StrToFloat(retorno);
  except
  end;
  Form.Caption := Titulo;
  Form.SomenteNumeros(UsarMoeda);
  if senha then
  begin
     form.Caixa.PasswordChar := '*';
     form.Caixa.CharCase := ecUpperCase;
  end;
  result := form.Executa(retorno);
end;


end.
