unit AAlteraItens;
{          Autor: Jorge Eduardo
    Data Criação: 19/10/1999;
          Função:
  Data Alteração:
    Alterado por:
Motivo alteração:
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, Grids, DBGrids, Tabela, DBKeyViolation, DBCtrls,
  Localizacao, Db, DBTables, ComCtrls, Componentes1, ExtCtrls, UnComandosAut,
  PainelGradiente, Mask, UNBancario, UnContasAPagar, UnContasAReceber, UnCaixa;

type
  TFAlteraItemCaixa = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    Localiza: TConsultaPadrao;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    ITECAIXA: TQuery;
    DATAITECAIXA: TDataSource;
    ITECAIXAVAL_MOVIMENTO: TFloatField;
    BEstornar: TBitBtn;
    AUX : TQuery;
    ITECAIXAEMP_FIL: TIntegerField;
    ITECAIXASEQ_DIARIO: TIntegerField;
    ITECAIXASEQ_PARCIAL: TIntegerField;
    ITECAIXASEQ_CAIXA: TIntegerField;
    ITECAIXACOD_OPERACAO: TIntegerField;
    ITECAIXACOD_FRM: TIntegerField;
    ITECAIXADAT_MOVIMENTO: TDateField;
    ITECAIXAHOR_MOVIMENTO: TTimeField;
    ITECAIXAVAL_PAGO_RECEBIDO: TFloatField;
    ITECAIXACREDITO_DEBITO: TStringField;
    ITECAIXALAN_PAGAR: TIntegerField;
    ITECAIXANRO_PAGAR: TIntegerField;
    ITECAIXALAN_RECEBER: TIntegerField;
    ITECAIXANRO_RECEBER: TIntegerField;
    ITECAIXAFLA_ESTORNADO: TStringField;
    GAlteraItem: TDBGridColor;
    ITECAIXACOD_OPERACAO_1: TIntegerField;
    ITECAIXACREDITO_DEBITO_1: TStringField;
    ITECAIXAFLA_TIPO: TStringField;
    ITECAIXACOD_USUARIO: TIntegerField;
    ITECAIXAI_COD_USU: TIntegerField;
    ITECAIXAC_NOM_USU: TStringField;
    ITECAIXADES_OPERACAO: TStringField;
    ITECAIXACOD_CLI: TIntegerField;
    ITECAIXAI_LAN_BAC: TIntegerField;
    ITECAIXAI_COD_CLI: TIntegerField;
    ITECAIXAC_NOM_CLI: TStringField;
    BBAjuda: TBitBtn;
    Aux1: TQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure ITECAIXAAfterScroll(DataSet: TDataSet);
    procedure BEstornarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ITECAIXAAfterPost(DataSet: TDataSet);
    procedure BBAjudaClick(Sender: TObject);
  private
    Caixa: TFuncoesCaixa;
    CP : TFuncoesContasAPagar;
    CR : TFuncoesContasAReceber;
    MB : TFuncoesBancario;
    procedure EstornaMovimento( VpaAlteracao: string);
    procedure PosicionaItensMovimento(VpaSequencialDiario, VpaSequencialParcial : string);
  public
    procedure EstornaCaixa;
    procedure AlteraCaixa( SeqDiario, SeqParcial : Integer );
  end;

var
  FAlteraItemCaixa: TFAlteraItemCaixa;
  AUT : TFuncoesAut;
implementation

{$R *.DFM}

uses
  Constantes, Fundata, Funstring, Funsql, APrincipal, ConstMsg, AItensCaixa, APermiteAlterar;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                   formulario
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{******************* na criacao do formulario ****************************** }
procedure TFAlteraItemCaixa.FormCreate(Sender: TObject);
begin
  AUT := TFuncoesAut.Create;
  Caixa := TFuncoesCaixa.Criar(Self, FPrincipal.BaseDados);
  Self.HelpFile := Varia.PathHelp + 'MCAIXA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
  if configmodulos.academico then
    GAlteraItem.Columns[8].Title.caption := 'Nome do aluno';

end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFAlteraItemCaixa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FechaTabela(ITECAIXA);
  FechaTabela(AUX);
  Aux1.close;
  Action := CaFree;
end;

{*************************** fecha formualrio ******************************* }
procedure TFAlteraItemCaixa.BFecharClick(Sender: TObject);
begin
  Close;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                estorno de caixa
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*************** chamada externa para estorno de caixa ********************* }
procedure TFAlteraItemCaixa.EstornaCaixa;
begin
  if caixa.CaixaAtivo(varia.CaixaPadrao) then
  begin
    PosicionaItensMovimento( IntToStr(Caixa.SequencialGeralAberto(varia.CaixaPadrao)),
                             IntToStr(Caixa.SequencialParcialAberto(varia.CaixaPadrao)));
    Self.ShowModal;
  end
  else
    self.close;
end;

{*************** chamada externa para alteracao de caixa ********************* }
procedure TFAlteraItemCaixa.AlteraCaixa( SeqDiario, SeqParcial : Integer ) ;
begin
  PosicionaItensMovimento( IntToStr(SeqDiario), IntToStr(SeqParcial) );
  Self.ShowModal;
end;

{ ****************** Na criação do Formulário ******************************** }
procedure TFAlteraItemCaixa.PosicionaItensMovimento(VpaSequencialDiario, VpaSequencialParcial : string);
begin
  AdicionaSQLAbreTabela(ITECAIXA, ' SELECT * FROM ITE_CAIXA CAI, CAD_TIPO_OPERA OPE, ' +
                                  ' CRP_PARCIAL CRP, CADUSUARIOS USU, CADCLIENTES CLI ' +
                                  ' WHERE CAI.EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil) +
                                  ' AND CAI.SEQ_DIARIO = ' + VpaSequencialDiario +
                                  ' AND CAI.SEQ_PARCIAL = ' + VpaSequencialParcial +
                                  ' AND CAI.FLA_PODE_ESTORNAR = ''S'' ' + // <> sangria/suprimento
                                  ' AND CAI.EMP_FIL = CRP.EMP_FIL ' +
                                  ' AND CAI.SEQ_DIARIO = CRP.SEQ_DIARIO ' +
                                  ' AND CAI.SEQ_PARCIAL = CRP.SEQ_PARCIAL ' +
                                  ' AND CAI.EMP_FIL = USU.I_EMP_FIL ' +
                                  ' AND CRP.COD_USUARIO = USU.I_COD_USU ' +
                                  ' AND CAI.COD_OPERACAO = OPE.COD_OPERACAO ' +
                                  ' AND CAI.COD_CLI *= CLI.I_COD_CLI ' +
                                  ' ORDER BY CAI.SEQ_CAIXA ');
end;

{****************** verifica os items que podem ser estronado *************** }
procedure TFAlteraItemCaixa.ITECAIXAAfterScroll(DataSet: TDataSet);
begin
  BEstornar.Enabled:=((ITECAIXAFLA_ESTORNADO.AsString <> 'S') and (not ITECAIXA.EOF));
end;

{*************** botao que chama o estorno ********************************** }
procedure TFAlteraItemCaixa.BEstornarClick(Sender: TObject);
var
  VpfAlteracao : string;
begin
  // veririca permicao para alterar
  VpfAlteracao := '';
  FPermiteAlterar := TFPermiteAlterar.CriarSDI(Application, '', FPrincipal.VerificaPermisao('FPermiteAlterar'));
  if FPermiteAlterar.CarregaTipoAlterar('E', ITECAIXACOD_USUARIO.AsString, VpfAlteracao, config.SenhaEstorno) then
     EstornaMovimento(VpfAlteracao);
end;

{************************* estorna o movimento ****************************** }
procedure TFAlteraItemCaixa.EstornaMovimento( VpaAlteracao: string);
var
  VpfEstornou: boolean;
  ponto : TBookmark;
begin
  if not FPrincipal.BaseDados.InTransaction then
    FPrincipal.BaseDados.StartTransaction;
  try
    if Confirmacao('Deseja realmente estornar este movimento ?') then
    begin
      VpfEstornou := True;
      case ITECAIXAFLA_TIPO.AsString[1] of
        'P' : begin // Estorna pagamento do conta a pagar;
                CP := TFuncoesContasAPagar.criar(self, fprincipal.BaseDados);
                CP.LocalizaParcela(AUX, ITECAIXALAN_PAGAR.AsInteger, ITECAIXANRO_PAGAR.AsInteger);
                CP.LocalizaContaCP(Aux1,ITECAIXALAN_PAGAR.AsInteger);
                if (not AUX.EOF) then
                  VpfEstornou:= CP.EstornaParcela(AUX.FieldByName('I_LAN_APG').AsInteger,
                                                  AUX.FieldByName('I_LAN_BAC').AsInteger,
                                                  AUX.FieldByName('I_NRO_PAR').AsInteger,
                                                  AUX.FieldByName('I_PAR_FIL').AsInteger,
                                                  AUX1.FieldByName('I_COD_CLI').AsInteger,
                                                  AUX.FieldByName('D_DAT_VEN').AsDateTime,
                                                  AUX.FieldByName('C_FLA_PAR').AsString, true);
                CP.Free;
              end;
        'R' : begin // Estorna pagamento conta a receber;
                CR := TFuncoesContasAReceber.criar(self, FPrincipal.BaseDados);
                CR.LocalizaParcela(AUX, ITECAIXALAN_RECEBER.AsInteger, ITECAIXANRO_RECEBER.AsInteger);
                CR.LocalizaContaCR(Aux1,ITECAIXALAN_RECEBER.AsInteger,ITECAIXAEMP_FIL.AsInteger);
                if (not AUX.EOF) then
                  VpfEstornou := CR.EstornaParcela( AUX.FieldByName('I_LAN_REC').AsInteger,
                                                    AUX.FieldByName('I_NRO_PAR').AsInteger,
                                                    AUX.FieldByName('I_LAN_BAC').AsInteger,
                                                    AUX.FieldByName('I_PAR_FIL').AsInteger,
                                                    AUX1.FieldByName('I_COD_CLI').AsInteger,
                                                    AUX.FieldByName('D_DAT_VEN').AsDateTime,
                                                    AUX.FieldByName('C_FLA_PAR').AsString, true);
                CR.Destroy;
              end;
         'O' : begin
                 if ITECAIXACREDITO_DEBITO.AsString = 'C' then
                 begin
                   CR := TFuncoesContasAReceber.criar(self, FPrincipal.BaseDados);
                   VpfEstornou := CR.ExcluiTitulo( ITECAIXALAN_RECEBER.AsInteger, ITECAIXANRO_RECEBER.AsInteger);
                   CR.Free;
                 end
                 else
                 begin
                   CP := TFuncoesContasAPagar.criar(self, fprincipal.BaseDados);
                   VpfEstornou := CP.ExcluiTitulo( ITECAIXALAN_PAGAR.AsInteger, ITECAIXANRO_PAGAR.AsInteger);
                   CP.Free;
                 end;
               end;
      end;

      // ESTORNA MOVIMENTAÇÃO DO CAIXA;
      if VpfEstornou then // só estorna se o título foi baixado ou não é conta a pagar ou receber.
      begin
        Caixa.GeraAlteracao(ITECAIXASEQ_DIARIO.AsInteger, ITECAIXASEQ_PARCIAL.AsInteger,
                            StrToInt(VpaAlteracao),ITECAIXACOD_USUARIO.AsInteger, ITECAIXASEQ_CAIXA.AsInteger, 'P');
        // estorna caixa
        if ITECAIXACREDITO_DEBITO.AsString = 'C' then
           caixa.EstornaCaixaCR(ITECAIXACOD_FRM.AsInteger,ITECAIXACOD_CLI.AsInteger,ITECAIXAVAL_MOVIMENTO.AsCurrency)
        else
           caixa.EstornaCaixaCP(ITECAIXACOD_FRM.AsInteger,ITECAIXACOD_CLI.AsInteger,ITECAIXAVAL_MOVIMENTO.AsCurrency);
      end;

      // atualiza consulta
      ponto := ITECAIXA.GetBookmark;
      AtualizaSQLTabela(ITECAIXA);
      if not ITECAIXA.Eof then
        ITECAIXA.GotoBookmark(ponto);
      ITECAIXA.FreeBookmark(ponto);
    end;

    Case varia.TipoImpressoraAUT of
        0 : begin end;
        1 : begin
              AUT.AbrePorta;
              AUT.Imprime('___________________________________');
              Aut.ImprimeFormato(' ESTORNO DE MOVIMENTO DE CAIXA ');
              AUT.Imprime('___________________________________');
              AUT.ImprimeFormato('Caixa: ' + inttostr(itecaixaSeq_diario.AsInteger)
                                 + itecaixaC_nom_usu.AsString
                                 + ' - ' + itecaixades_operacao.asstring
                                 + 'Data: ' + datetostr(iteCaixaDat_movimento.asdatetime)
                                 + 'hora: ' + timetostr(itecaixaHor_movimento.AsDateTime));
              AUT.ImprimeFormato('Nome: ' +  itecaixac_nom_cli.asString
                                           + ' ' + formatfloat('#0.00',ITECAIXAVAL_MOVIMENTO.AsCurrency));
              AUT.Imprime('___________________________________');
            end;
    end;
  except
    Aviso('Houve um erro nesta operação e a mesma será desfeita totalmente.');
    if FPrincipal.BaseDados.InTransaction then
     FPrincipal.BaseDados.Rollback;
  end;

  if FPrincipal.BaseDados.InTransaction then
    FPrincipal.BaseDados.Commit;
end;

procedure TFAlteraItemCaixa.ITECAIXAAfterPost(DataSet: TDataSet);
begin
  GAlteraItem.ReadOnly := True;
  ITECAIXA.RequestLive := False;
end;


procedure TFAlteraItemCaixa.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FAlteraItemCaixa.HelpContext);
end;



Initialization
 RegisterClasses([TFAlteraItemCaixa]);
end.
