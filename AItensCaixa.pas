unit AItensCaixa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  formularios, StdCtrls, Buttons, ExtCtrls, Componentes1, Localizacao,
  LabelCorMove, PainelGradiente, UnCaixa, Mask, numericos, DBKeyViolation,
  DBCtrls, Tabela, Db, DBTables, UnECf, UnComandosAUT,
  UnContasAPagar, UnContasAReceber, UnMoedas,  UnBancario, UnComissoes1,
  Grids, DBGrids, ComCtrls;

type
  TFItensCaixa = class(TFormularioPermissao)
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    Localiza: TConsultaPadrao;
    LCaixa: TLabel;
    PTitulo: TPainelGradiente;
    CaixaPanel: TPanelColor;
    NItensCaixa: TNotebook;
    ETipoOperacao: TEditLocaliza;
    Label1: TLabel;
    LCaixaAtivo: TLabel3D;
    LTipoOpera: TLabel;
    BConfirmaOperacao: TBitBtn;
    Label8: TLabel;
    EDataPagamento: TMaskEditColor;
    Label10: TLabel;
    EDescontoPagar: TNumerico;
    Label15: TLabel;
    EAcrescimoPagar: TNumerico;
    BaixaPagar: TQuery;
    BaixaPagarI_EMP_FIL: TIntegerField;
    BaixaPagarI_LAN_APG: TIntegerField;
    BaixaPagarI_NRO_PAR: TIntegerField;
    BaixaPagarC_NRO_DUP: TStringField;
    BaixaPagarD_DAT_VEN: TDateField;
    BaixaPagarN_VLR_DUP: TFloatField;
    BaixaPagarD_DAT_PAG: TDateField;
    BaixaPagarN_PER_JUR: TFloatField;
    BaixaPagarN_VLR_DES: TFloatField;
    BaixaPagarN_VLR_PAG: TFloatField;
    BaixaPagarI_COD_USU: TIntegerField;
    BaixaPagarN_PER_MOR: TFloatField;
    BaixaPagarN_PER_DES: TFloatField;
    BaixaPagarN_VLR_ACR: TFloatField;
    BaixaPagarN_VLR_JUR: TFloatField;
    BaixaPagarN_VLR_MOR: TFloatField;
    BaixaPagarN_PER_MUL: TFloatField;
    BaixaPagarN_VLR_MUL: TFloatField;
    BaixaPagarI_COD_FRM: TIntegerField;
    BaixaPagarC_FLA_PAR: TStringField;
    BaixaPagarL_OBS_APG: TMemoField;
    BaixaPagarI_PAR_FIL: TIntegerField;
    DataBaixaPagar: TDataSource;
    Label4: TLabel;
    DataReceber: TMaskEditColor;
    Label6: TLabel;
    EDescontoReceber: TNumerico;
    Label9: TLabel;
    EAcrescimoReceber: TNumerico;
    BaixaReceber: TQuery;
    DataBaixaReceber: TDataSource;
    ITE_CAIXA: TQuery;
    ITE_CAIXAEMP_FIL: TIntegerField;
    ITE_CAIXASEQ_DIARIO: TIntegerField;
    ITE_CAIXASEQ_PARCIAL: TIntegerField;
    ITE_CAIXASEQ_CAIXA: TIntegerField;
    ITE_CAIXACOD_OPERACAO: TIntegerField;
    ITE_CAIXACOD_FRM: TIntegerField;
    ITE_CAIXADAT_MOVIMENTO: TDateField;
    ITE_CAIXAHOR_MOVIMENTO: TTimeField;
    ITE_CAIXAVAL_MOVIMENTO: TFloatField;
    ITE_CAIXAVAL_PAGO_RECEBIDO: TFloatField;
    ITE_CAIXACREDITO_DEBITO: TStringField;
    ITE_CAIXALAN_PAGAR: TIntegerField;
    ITE_CAIXANRO_PAGAR: TIntegerField;
    ITE_CAIXALAN_RECEBER: TIntegerField;
    ITE_CAIXANRO_RECEBER: TIntegerField;
    TTempo: TPainelTempo;
    BTipoOpera: TSpeedButton;
    BaixaReceberI_EMP_FIL: TIntegerField;
    BaixaReceberI_LAN_REC: TIntegerField;
    BaixaReceberI_NRO_PAR: TIntegerField;
    BaixaReceberI_COD_FRM: TIntegerField;
    BaixaReceberD_DAT_VEN: TDateField;
    BaixaReceberD_DAT_PAG: TDateField;
    BaixaReceberN_VLR_PAR: TFloatField;
    BaixaReceberN_VLR_DES: TFloatField;
    BaixaReceberN_TOT_PAR: TFloatField;
    BaixaReceberN_VLR_PAG: TFloatField;
    BaixaReceberN_PER_MOR: TFloatField;
    BaixaReceberN_PER_JUR: TFloatField;
    BaixaReceberN_PER_MUL: TFloatField;
    BaixaReceberN_PER_COR: TFloatField;
    BaixaReceberI_COD_USU: TIntegerField;
    BaixaReceberN_VLR_ENT: TFloatField;
    BaixaReceberC_NRO_DUP: TStringField;
    BaixaReceberN_DES_VEN: TFloatField;
    BaixaReceberC_FLA_PAR: TStringField;
    BaixaReceberL_OBS_REC: TMemoField;
    BaixaReceberI_PAR_FIL: TIntegerField;
    BaixaReceberI_PAR_MAE: TIntegerField;
    BaixaReceberI_DIA_CAR: TIntegerField;
    BaixaReceberN_PER_ACR: TFloatField;
    BaixaReceberN_PER_DES: TFloatField;
    BaixaReceberI_FIL_PAG: TIntegerField;
    BaixaReceberC_DUP_CAN: TStringField;
    BaixaReceberN_VLR_ACR: TFloatField;
    AUX: TQuery;
    ITE_CAIXAFLA_ESTORNADO: TStringField;
    BaixaPagarC_BAI_BAN: TStringField;
    BaixaPagarC_DUP_CAN: TStringField;
    LPago: TLabel;
    EPagoValor: Tnumerico;
    LTroco: TLabel;
    EPagarTroco: Tnumerico;
    LValorLanc: TLabel;
    EPagarValor: Tnumerico;
    Label21: TLabel;
    EOutroValor: Tnumerico;
    LOutroTitulo: TLabel;
    EOutroPagoRecebido: Tnumerico;
    EReceberTroco: Tnumerico;
    Label7: TLabel;
    Label12: TLabel;
    Label20: TLabel;
    ITE_CAIXAC_CLA_PLA: TStringField;
    ITE_CAIXAI_COD_EMP: TIntegerField;
    ITE_CAIXAI_LAN_BAC: TIntegerField;
    LUUU: TLabel;
    Label23: TLabel;
    SpeedButton3: TSpeedButton;
    EFormaPagtoOutros: TEditLocaliza;
    Label25: TLabel;
    Label31: TLabel;
    BFormaPagtoReceber: TSpeedButton;
    Label33: TLabel;
    LPlanoContas: TLabel;
    EPlanoOutros: TEditColor;
    BPlano: TSpeedButton;
    LPlano: TLabel;
    ITE_CAIXACOD_CLI: TIntegerField;
    BaixaReceberI_LAN_BAC: TIntegerField;
    EReceberAdicionais: Tnumerico;
    Label35: TLabel;
    BaixaReceberN_VLR_ADI: TFloatField;
    BAdicionais: TSpeedButton;
    BaixaReceberI_COD_SIT: TIntegerField;
    BaixaReceberI_NUM_BOR: TIntegerField;
    NPesquisaReceber: TNotebook;
    Label17: TLabel;
    EDuplicataReceber: TEditLocaliza;
    BDuplicataReceber: TSpeedButton;
    Label16: TLabel;
    ENotaReceber: TEditLocaliza;
    BNotaReceber: TSpeedButton;
    CPesquisaReceber: TComboBoxColor;
    Label11: TLabel;
    Label14: TLabel;
    EFormaPagtoReceber: TEditLocaliza;
    EReceberValor: Tnumerico;
    Label2: TLabel;
    EFormaPagtoPagar: TEditLocaliza;
    BFormaPagtoPagar: TSpeedButton;
    Label3: TLabel;
    CPesquisaPagar: TComboBoxColor;
    NPesquisaPagar: TNotebook;
    Label18: TLabel;
    ENotaPagar: TEditLocaliza;
    BNotaPagar: TSpeedButton;
    Label30: TLabel;
    EDuplicataPagar: TEditLocaliza;
    BDuplicataPagar: TSpeedButton;
    LPag: TLabel;
    ERecebidoValor: Tnumerico;
    Label5: TLabel;
    EOrdemPagar: TEditLocaliza;
    SpeedButton7: TSpeedButton;
    Label19: TLabel;
    EOrdemReceber: TEditLocaliza;
    SpeedButton8: TSpeedButton;
    LAtrazoReceber: TLabel;
    LAtrazoPagar: TLabel;
    Label34: TLabel;
    DBEditColor1: TDBEditColor;
    DBEditColor3: TDBEditColor;
    Label37: TLabel;
    BaixaReceberI_COD_MOE: TIntegerField;
    BaixaPagarI_COD_MOE: TIntegerField;
    MObsReceber: TMemoColor;
    LdiasReceber: TLabel;
    Label13: TLabel;
    Label24: TLabel;
    MObsPagar: TMemoColor;
    Label26: TLabel;
    Label27: TLabel;
    LDiasPagar: TLabel;
    cadBaixaPagar: TQuery;
    cadBaixaPagarI_LAN_APG: TIntegerField;
    cadBaixaPagarI_EMP_FIL: TIntegerField;
    cadBaixaPagarI_COD_CLI: TIntegerField;
    cadBaixaPagarC_CLA_PLA: TStringField;
    cadBaixaPagarC_FLA_DES: TStringField;
    Label28: TLabel;
    EFornecedor: TEditLocaliza;
    SpeedButton1: TSpeedButton;
    Label29: TLabel;
    Label32: TLabel;
    EClienteReceber: TEditLocaliza;
    SpeedButton2: TSpeedButton;
    Label36: TLabel;
    EclientePagar: TEditLocaliza;
    SpeedButton4: TSpeedButton;
    ENotaOutro: TNumerico;
    Label38: TLabel;
    BAutenticacao: TBitBtn;
    BBAjuda: TBitBtn;
    Label22: TLabel;
    numerico1: Tnumerico;
    Label39: TLabel;
    EditColor2: TEditColor;
    ECPF: TMaskEditColor;
    Label40: TLabel;
    BitBtn2: TBitBtn;
    Label41: TLabel;
    EditColor1: TEditColor;
    EditLocaliza1: TEditLocaliza;
    Label42: TLabel;
    SpeedButton5: TSpeedButton;
    Label43: TLabel;
    CadBaixaReceber: TQuery;
    CadCaixa: TQuery;
    Label45: TLabel;
    numerico3: Tnumerico;
    EditLocaliza2: TEditLocaliza;
    Label46: TLabel;
    SpeedButton6: TSpeedButton;
    Label47: TLabel;
    EditLocaliza3: TEditLocaliza;
    Label44: TLabel;
    SpeedButton9: TSpeedButton;
    Label48: TLabel;
    GridIndice1: TGridIndice;
    MudaForma: TQuery;
    DataMudaForma: TDataSource;
    MudaFormai_nro_not: TIntegerField;
    MudaFormac_nom_cli: TStringField;
    MudaFormac_nom_frm: TStringField;
    MudaForman_vlr_par: TFloatField;
    MudaFormai_cod_cli: TIntegerField;
    MudaFormai_cod_frm: TIntegerField;
    MudaFormai_nro_par: TIntegerField;
    MudaFormai_lan_rec: TIntegerField;
    BitBtn1: TBitBtn;
    MudaFormad_dat_emi: TDateField;
    MudaFormac_fla_tip: TStringField;
    MudaFormaC_FLA_BCR: TStringField;
    NFiscal: Tnumerico;
    Label49: TLabel;
    Label50: TLabel;
    EditLocaliza4: TEditLocaliza;
    SpeedButton10: TSpeedButton;
    Label51: TLabel;
    Label52: TLabel;
    Data1: TCalendario;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure ETipoOperacaoRetorno(Retorno1, Retorno2: String);
    procedure ENotaPagarSelect(Sender: TObject);
    procedure EDuplicataPagarSelect(Sender: TObject);
    procedure BConfirmaOperacaoClick(Sender: TObject);
    procedure ENotaReceberSelect(Sender: TObject);
    procedure EDuplicataReceberSelect(Sender: TObject);
    procedure EPlanoOutrosExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BAdicionaisClick(Sender: TObject);
    procedure EPlanoOutrosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ReceberRetorno(Retorno1, Retorno2: String);
    procedure CPesquisaReceberChange(Sender: TObject);
    procedure CPesquisaPagarChange(Sender: TObject);
    procedure PagarRetorno(Retorno1, Retorno2: String);
    procedure ERecebidoValorExit(Sender: TObject);
    procedure EPagoValorExit(Sender: TObject);
    procedure EPagoValorChange(Sender: TObject);
    procedure EDescontoReceberChange(Sender: TObject);
    procedure EDescontoPagarChange(Sender: TObject);
    procedure EOrdemPagarSelect(Sender: TObject);
    procedure EOrdemReceberSelect(Sender: TObject);
    procedure ETipoOperacaoSelect(Sender: TObject);
    procedure ERecebidoValorChange(Sender: TObject);
    procedure EFormaPagtoPagarRetorno(Retorno1, Retorno2: String);
    procedure EFormaPagtoReceberRetorno(Retorno1, Retorno2: String);
    procedure EFormaPagtoOutrosRetorno(Retorno1, Retorno2: String);
    procedure EFornecedorCadastrar(Sender: TObject);
    procedure EFornecedorSelect(Sender: TObject);
    procedure EClienteReceberSelect(Sender: TObject);
    procedure EclientePagarSelect(Sender: TObject);
    procedure EFormaPagtoOutrosChange(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure numerico1Change(Sender: TObject);
    procedure EditLocaliza2Change(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure NFiscalExit(Sender: TObject);
  private
    { Private declarations }
    BaixarBanco: Boolean;
    VprSeqDiario,  // Alteração.
    VprSeqParcial, // Alteração.
    VprAtivo: Integer;
    UsarECF : Boolean; // caso o caixa utilize ecf
    Caixa: TFuncoesCaixa;
    Alterando: Boolean;   // Alteração.
    VprCreditoDebito: string;
    VprTipoOperacao: char;
    CP : TFuncoesContasAPagar;
    CR : TFuncoesContasAReceber;
    ECF : TECF;
    Comissoes : TFuncoesComissao;
    Moedas : TFuncoesMoedas;

    // receber
    ValorParcelaReceber : Double;
    TipoFRMPagtoReceber,
    FlagFRMReceber, FlagFRMPagar : string;

    // pagar
    ValorParcelaPagar : double;
    TipoFRMPagtoPagar : string;

    //outros
    tipoFRMpagtoOutros : string;
    LancamentoOutros : integer;

    // CONTAS A PAGAR //
    procedure CalculaValoresPagar;
    procedure LimpaEditsPagar;
    function CarregaBaixaParcelaPagar( numeroLancamento, numeroparcela : integer) : Boolean;
    procedure BaixaContaApagar;
    // CONTAS A RECEBER //
    procedure LimpaEditsReceber;
    procedure CalculaValoresReceber;
    function CarregaBaixaParcelaReceber( numeroLancamento, numeroparcela : integer) : Boolean;
    procedure BaixaContaReceber;
    // outros
    procedure lancamentoCP;
    procedure lancamentoCR;
    procedure AbreMudaForma;
    procedure AlteraFormaPagto;

    // procedure LancaCaixaOutros;
    procedure limpaEditsOutro;

    // Troca valores
    procedure TrocaChequeDinheiro;
    // gaveta
    procedure AcionaGaveta( FormaPagamento : string );
    procedure HabilitaAutenticacao( Estado : Boolean );
  public
    { Public declarations }
    // ABERTURA DA TELA //
    function ValidaCarregaAbertura : boolean;
    procedure AutenticaDocumento(usuario, data, doc, parcela, formapagto, valor, operacao, tipo : string; lan : integer);
  end;

var
  FItensCaixa: TFItensCaixa;
  AUT : TFuncoesAUT;
implementation

{$R *.DFM}

  uses ConstMsg, APrincipal, Constantes, FunSQL, AAlteraItens,
  APermiteAlterar, APlanoConta, FunObjeto, FunNumeros, AAdicionais,
  ANovoCliente, AReportRecibos, AFormaPagtoCR1;


{ ****************** Na criação do Formulário ******************************** }
procedure TFItensCaixa.FormCreate(Sender: TObject);
begin
  data1.DateTime := date;
// ECF
  ECF := TECF.criar(nil, FPrincipal.BaseDados);
  AUT := TFuncoesAut.Create;
  // caixa
  Caixa := TFuncoesCaixa.Criar(self, FPrincipal.BaseDados);
  UsarECF := Caixa.CaixaUsaEcf( varia.CaixaPadrao );
  if UsarECF then
    if not ECF.AbrePorta then
       aviso(CT_ImpressoraFiscalFechada);
  HabilitaAutenticacao( UsarECF );

  // CONTAS A PAGAR
  CP := TFuncoesContasAPagar.Criar(self, Fprincipal.BaseDados);
  // CONTAS A RECEBER
  CR := TFuncoesContasAReceber.Criar(self, FPrincipal.BaseDados);
//  MOEDAS
  Moedas := TFuncoesMoedas.Criar(self, Fprincipal.BaseDados);
  NPesquisaReceber.PageIndex := 0;
  CPesquisaReceber.ItemIndex := 0;
  NPesquisaPagar.PageIndex := 0;
  CPesquisaPagar.ItemIndex := 0;
  BaixarBanco := False;
  LancamentoOutros := 0;
  DataReceber.EditMask := FPrincipal.CorFoco.AMascaraData;
  EDataPagamento.EditMask := FPrincipal.CorFoco.AMascaraData;
  Self.HelpFile := Varia.PathHelp + 'MCAIXA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
  if configmodulos.academico then
  begin
    CPesquisaReceber.Items.Strings[0] := 'Contrato';
    CPesquisaReceber.Items.Strings[3] := 'Cliente';
    label32.Caption := 'Cliente';
    Label16.Caption := 'Contrato';
  end;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFItensCaixa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ECF.FecharPorta;
  BaixaPagar.Cancel;
  BaixaReceber.Cancel;

  FechaTabela(BaixaPagar);
  FechaTabela(BaixaReceber);
  FechaTabela(cadBaixaPagar);
  FechaTabela(CadBaixaReceber);
  FechaTabela(ITE_CAIXA);
  FechaTabela(AUX);
  FechaTabela(MudaForma);
  if FPrincipal.BaseDados.InTransaction then
    FPrincipal.BaseDados.Rollback;
  CP.Destroy;
  CR.Destroy;
  Caixa.Free;
  ECF.Free;
  Moedas.Destroy;
  Action := CaFree;
end;

{******************* valida a abertura do formulario ************************* }
function TFItensCaixa.ValidaCarregaAbertura : Boolean;
begin
  Result := caixa.CaixaAtivo(varia.CaixaPadrao);
  LCaixaAtivo.Caption :=  'Caixa Nro ' + IntToStr(varia.CaixaPadrao) + '.';
  if result then
  begin
    Alterando:=False; // Caixa Normal.
    Self.ShowModal;
  end
  else
    self.close;
end;

{****************** configura o tipo de operacao ***************************** }
procedure TFItensCaixa.ETipoOperacaoRetorno(Retorno1, Retorno2: String);
begin
  if (Retorno1 <> '') then
  begin
    BConfirmaOperacao.Enabled := true;
    NItensCaixa.Visible:=True;
    LPlanoContas.Visible:=True;
    VprTipoOperacao := UpperCase(Retorno1)[1];

    case VprTipoOperacao of
      'P' : begin NItensCaixa.PageIndex:=0; HabilitaAutenticacao(false); end; // CONTAS A PAGAR.
      'R' : begin NItensCaixa.PageIndex:=1; HabilitaAutenticacao(true);  end;  // CONTAS A RECEBER.
      'C' : begin NItensCaixa.PageIndex:=3; HabilitaAutenticacao(true);  BConfirmaOperacao.Enabled := false; end;  // RECIBO.
      'H' : begin NItensCaixa.PageIndex:=4; HabilitaAutenticacao(true);  BConfirmaOperacao.Enabled := false; end;  // TROCA.
      'F' : begin NItensCaixa.PageIndex:=5; HabilitaAutenticacao(false); AbreMudaForma; end; // MUDA FORMA DE PAGAMENTO.
        else
        begin
          BConfirmaOperacao.Enabled := false;
          NItensCaixa.PageIndex:=2; // OUTROS TIPOS
          EOutroValor.AValor:=0;
          EOutroPagoRecebido.AValor:=0;
        end;
    end;
    if (Retorno2 <> '') then
      case UpperCase(Retorno2)[1] of
        'C' : begin
                LOutroTitulo.Caption:='Valor Recebido :'; // CRÉDITO
                VprCreditoDebito:='C';
              end;
        'D' : begin
                LOutroTitulo.Caption:='Valor Pago :';     // DÉBITO
                VprCreditoDebito:='D';
              end;
      end;
  end;
end;

{******************* na abertura do formulario ****************************** }
procedure TFItensCaixa.FormShow(Sender: TObject);
begin
  // Permite Gerar Parciais - não altera o valor.
  EReceberValor.ReadOnly := (not Config.PermitirParcial);
  EPagarValor.ReadOnly := (not Config.PermitirParcial);
end;

{****************** fecha o formulario ************************************** }
procedure TFItensCaixa.BFecharClick(Sender: TObject);
begin
  Close;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           contas a pagar
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{ ***** RETORNO PARA CARREGAR A CONTA A PAGAR ***** }
procedure TFItensCaixa.PagarRetorno(Retorno1, Retorno2: String);
begin
  if (Retorno1 <> '') then
    CarregaBaixaParcelaPagar(StrToInt(Retorno1), StrToInt(Retorno2))
  else
    FechaTabela(BaixaPagar);
  BFormaPagtoPagar.Enabled := (Retorno1 <> '');
end;


{ ***** select por número da nota ***** }
procedure TFItensCaixa.ENotaPagarSelect(Sender: TObject);
begin
  ENotaPagar.ASelectValida.Clear;
  ENotaPagar.ASelectValida.Add(' Select C.c_nom_CLI, CPM.I_LAN_APG, CPM.I_NRO_PAR from CadContasAPagar CP key join MovContasAPagar CPM, CadClientes C ' +
                               ' where CP.I_COD_CLI = C.I_COD_CLI ' +
                               ' AND CP.I_EMP_FIL = ' + IntToStr(varia.CodigoEmpFil) +
                               ' AND CPM.D_DAT_PAG IS NULL ' +
                               ' and isnull(CPM.C_DUP_CAN, ''N'') = ''N'' ' +
                               ' and CP.I_NRO_NOT = @');
  ENotaPagar.ASelectLocaliza.Clear;
  ENotaPagar.ASelectLocaliza.Add(' Select CPM.I_LAN_APG, CPM.I_NRO_PAR, CP.I_NRO_NOT, C.C_NOM_CLI, C.I_COD_CLI ' +
                                 ' from CadContasAPagar CP key join MovContasAPagar CPM, CadClientes C  ' +
                                 ' where CP.I_EMP_FIL = ' + IntTostr(varia.CodigoEmpFil) +
                                 ' AND CPM.D_DAT_PAG IS NULL ' +
                                 ' and isnull(CPM.C_DUP_CAN, ''N'') = ''N'' ' +
                                 ' and CP.I_COD_CLI = C.I_COD_CLI and c_nom_CLI like ''@%''' +
                                 ' and not CP.I_NRO_NOT is null ');
end;

{ ***** select por duplicata ***** }
procedure TFItensCaixa.EDuplicataPagarSelect(Sender: TObject);
begin
  EDuplicataPagar.ASelectValida.Clear;
  EDuplicataPagar.ASelectValida.Add(' Select MCP.I_EMP_FIL,MCP.I_LAN_APG, C.C_NOM_CLI, CP.I_NRO_NOT, MCP.I_NRO_PAR ' +
                                    ' from MovContasaPagar as MCP Key join CadContasAPagar as CP, CadClientes as C' +
                                    ' where CP.I_COD_CLI = C.I_COD_CLI ' +
                                    ' and MCP.I_EMP_FIL = ' + IntTostr(varia.CodigoEmpFil) +
                                    ' and MCP.D_DAT_PAG IS NULL ' + // CONTA NÃO FOI PAGA
                                    ' and isnull(MCP.C_DUP_CAN, ''N'') = ''N'' ' +
                                    ' and C_NRO_DUP = ''@''');
  EDuplicataPagar.ASelectLocaliza.Clear;
  EDuplicataPagar.ASelectLocaliza.Add(' Select MCP.I_EMP_FIL,MCP.I_LAN_APG, C.C_NOM_CLI, CP.I_NRO_NOT, MCP.C_NRO_DUP, MCP.I_NRO_PAR ' +
                                      ' from MovContasaPagar as MCP Key join CadContasAPagar as CP, CadClientes as C' +
                                      ' where CP.I_COD_CLI = C.I_COD_CLI and C.C_TIP_CAD <> ''C''' +
                                      ' and MCP.I_EMP_FIL = ' + IntTostr(varia.CodigoEmpFil) +
                                      ' and MCP.D_DAT_PAG IS NULL ' + // CONTA NÃO FOI PAGA
                                      ' and isnull(MCP.C_DUP_CAN, ''N'') = ''N'' ' +
                                      ' and MCP.C_NRO_DUP like ''@%''');
end;

{****************** select por ordem ***************************************** }
procedure TFItensCaixa.EOrdemPagarSelect(Sender: TObject);
begin
  EOrdemPagar.ASelectValida.Clear;
  EOrdemPagar.ASelectValida.Add(' Select C.c_nom_CLI, CPM.I_LAN_APG, CPM.I_NRO_PAR from CadContasAPagar CP key join MovContasAPagar CPM, CadClientes C ' +
                                ' where CP.I_COD_CLI = C.I_COD_CLI ' +
                                ' AND CP.I_EMP_FIL = ' + IntToStr(varia.CodigoEmpFil) +
                                ' AND CPM.D_DAT_PAG IS NULL ' +
                                ' and isnull(CPM.C_DUP_CAN, ''N'') = ''N'' ' +
                                ' and CPM.I_LAN_APG = @');
  EOrdemPagar.ASelectLocaliza.Clear;
  EOrdemPagar.ASelectLocaliza.Add(' Select CPM.I_LAN_APG, CPM.I_NRO_PAR, C.C_NOM_CLI ' +
                                  ' from CadContasAPagar CP key join MovContasAPagar CPM, CadClientes C  ' +
                                  ' where CP.I_EMP_FIL = ' + IntTostr(varia.CodigoEmpFil) +
                                  ' AND CPM.D_DAT_PAG IS NULL ' +
                                  ' and CP.I_COD_CLI = C.I_COD_CLI ' +
                                  ' and isnull(CPM.C_DUP_CAN, ''N'') = ''N'' ' +
                                  ' and CPM.I_LAN_APG like ''@%''' );
end;

{***************** select do cliente do contas a pagar ********************* }
procedure TFItensCaixa.EclientePagarSelect(Sender: TObject);
begin
  EclientePagar.ASelectValida.Clear;
  EclientePagar.ASelectValida.Add( ' select cad.i_lan_apg, mov.i_nro_par, cli.i_cod_cli, cli.c_nom_cli, cad.i_nro_not, mov.n_vlr_dup ' +
                                   ' from CadClientes as cli, ' +
                                   ' CadContasAPagar as cad key join MovcontasaPagar as mov ' +
                                   ' where cli.I_COD_CLI = @ ' +
                                   ' and cad.i_cod_cli = cli.i_cod_cli ' +
                                   ' AND Mov.D_DAT_PAG IS NULL ' +
                                   ' and isnull(Mov.C_DUP_CAN, ''N'') = ''N'' '  );
  EclientePagar.ASelectLocaliza.Clear;
  EclientePagar.ASelectLocaliza.Add(' select cad.i_lan_apg, mov.i_nro_par, cli.i_cod_cli, cli.c_nom_cli, cad.i_nro_not, mov.n_vlr_dup ' +
                                    ' from CadClientes as cli, ' +
                                    ' CadContasAPagar as cad key join MovcontasaPagar as mov' +
                                    ' where cli.c_nom_cli like ''@%'' ' +
                                    ' and cad.i_cod_cli = cli.i_cod_cli ' +
                                    ' AND Mov.D_DAT_PAG IS NULL ' +
                                    ' and isnull(Mov.C_DUP_CAN, ''N'') = ''N'' '  );

end;


{ ***** limpa os edits do conta a pagar ***** }
procedure TFItensCaixa.LimpaEditsPagar;
begin
  LAtrazoPagar.Caption := '';
  EPagarValor.AValor:=0;
  EPagoValor.AValor:=0;
  EDescontoPagar.AValor:=0;
  EAcrescimoPagar.AValor:=0;
  EDuplicataPagar.Clear;
  EPagarTroco.AValor:=0;
  MObsPagar.lines.clear;
  EFormaPagtoPagar.Text := '';
  EFormaPagtoPagar.Atualiza;
  LDiasPagar.Caption := '';
  FechaTabela(BaixaPagar);
  FechaTabela(cadBaixaPagar);
  FechaTabela(CadBaixaReceber);
  EDuplicataPagar.text :='';
  EOrdemPagar.text := '';
  ENotaPagar.text := '';
end;

{******************** carrega parcelas a ser baixa *************************** }
function TFItensCaixa.CarregaBaixaParcelaPagar( numeroLancamento, numeroparcela : integer) : Boolean;
begin
  Result := true;

  if numeroparcela <> 0 then
    CP.LocalizaParcelaAberta(BaixaPagar,numerolancamento, numeroparcela)
  else
    CP.LocalizaParcelasAbertas(BaixaPagar,numerolancamento,'D_DAT_VEN');

  CP.LocalizaContaCP(cadBaixaPagar, numeroLancamento);

  if not baixaPagar.Eof then
    CalculaValoresPagar
  else
  begin
    aviso(CT_TodaParcelasPagas);
    result := false;
  end;
end;

{********************** define o tipo de pesquisa ************************** }
procedure TFItensCaixa.CPesquisaPagarChange(Sender: TObject);
begin
  NPesquisaPagar.PageIndex := CPesquisaPagar.ItemIndex;
  LimpaEditsPagar;
end;

{***********o valor recebido naum pode ser menor que o pago ***************** }
procedure TFItensCaixa.EPagoValorExit(Sender: TObject);
begin
  if (EPagoValor.AValor < EPagarValor.AValor) then
  begin
    EPagoValor.AValor := EPagoValor.AValor;
    Aviso(CT_Valor_Invalido);
  end;
end;

{********************************* troco ************************************ }
procedure TFItensCaixa.EPagoValorChange(Sender: TObject);
begin
  EPagarTroco.AValor := (EPagoValor.AValor - EPagarValor.AValor);
end;

{************************ valor total das parcelas ************************* }
procedure TFItensCaixa.EDescontoPagarChange(Sender: TObject);
begin
  EPagarValor.AValor := ValorParcelaPagar + EAcrescimoPagar.AValor - EDescontoPagar.AValor;
  EPagoValor.AValor := EPagarValor.AValor;
end;

{ ******************** calcula o valor dos juros ***************************** }
procedure TFItensCaixa.CalculaValoresPagar;
var
  multa, mora, juro, desconto : double;
  uni : string;
  Moedas : TFuncoesMoedas;
begin
  ValorParcelaPagar := baixaPagarN_VLR_DUP.AsCurrency;

  MObsPagar.Lines.Clear;
  MObsPagar.Lines.Add(BaixaPagarL_OBS_APG.AsString);
  EDataPagamento.Text := DateToStr(date);
  EFormaPagtoPagar.Text := BaixaPagarI_COD_FRM.AsString;
  EFormaPagtoPagar.Atualiza;

  // verifica moeda e converte para o pagamento
  if BaixaPagarI_cod_moe.AsInteger <> varia.MoedaBase then
  begin
     Moedas := TFuncoesMoedas.criar(self, FPrincipal.BaseDados);
     ValorParcelaPagar := Moedas.ConverteValorParaMoedaBase(uni, BaixaPagarI_COD_MOE.AsInteger, date, baixaPagarN_VLR_DUP.AsCurrency);
     MObsPagar.Lines.Text := MObsPagar.Lines.Text +  '  - Valor original ' + uni + ' ' + FormatFloat(varia.MascaraValor, baixaPAgarN_VLR_DUP.AsCurrency);
     Moedas.Free;
  end;

  LDiasPagar.Caption := InTToStr(CP.CalculaJuros( multa,mora,juro,desconto,BaixaPagarD_DAT_VEN.AsDateTime,date,BaixaPagarI_LAN_APG.AsInteger,BaixaPagarI_NRO_PAR.AsInteger));

  EAcrescimoPagar.Avalor := multa + mora + juro;
  EDescontoPagar.AValor := desconto;
  EPagarValor.AValor := ValorParcelaPagar + multa + mora +  Juro - desconto;
  EPagoValor.AValor := EPagarValor.AValor;
end;

{*************** confirma a baixa ******************************************** }
procedure TFItensCaixa.BaixaContaApagar;
var
  Dados : TDadosBaixaCP;
  lan : integer;
begin
  AcionaGaveta(EFormaPagtoPagar.text);
  try
    if not FPrincipal.BaseDados.InTransaction then
      FPrincipal.BaseDados.StartTransaction;
      Dados := TDadosBaixaCP.Create;
      Dados.LancamentoCP := BaixaPagarI_LAN_APG.AsInteger;
      lan := BaixaPagarI_LAN_APG.AsInteger;
      Dados.NroParcela := BaixaPagarI_NRO_PAR.AsInteger;
      Dados.CodUsuario := varia.CodigoUsuario;
      Dados.CodMoedaAtual := BaixaPagarI_COD_MOE.AsInteger;
      Dados.DataPagamento := StrToDate(EDataPagamento.Text);
      Dados.ValorDesconto := EDescontoPagar.AValor;
      Dados.valorAcrescimo := EAcrescimoPagar.AValor;
      Dados.ValorPago := EPagarValor.AValor;
      Dados.Observacao := MObsPagar.Lines.Text;
      Dados.VerificarCaixa := true;
      Dados.TipoFrmPagto := TipoFRMPagtoPagar;
      dados.CodFormaPAgamento := strToInt(EFormaPagtoPagar.text);
      dados.VerficarFormaPagamento := true;
      dados.VerificaBanco := true;
      dados.FlagDespesaFixa := cadBaixaPagarC_FLA_DES.AsString;
      dados.PlanoConta := cadBaixaPagarC_CLA_PLA.AsString;
      dados.TrocoCaixa := EPagarTroco.avalor;
      dados.ValorTotalAserPago := ValorParcelaPagar +  Dados.valorAcrescimo - Dados.ValorDesconto;

      if CP.BaixaContaAPagar( dados ) then
      begin
        Dados.Free;
        if FPrincipal.BaseDados.InTransaction then
          FPrincipal.BaseDados.commit;

       // lanca no ecf
       if (UsarECF) and (FlagFRMPagar = 'C') then
          ECF.Sangria_Suprimento( EPagarValor.AValor, true );
        LimpaEditsPagar;

       AutenticaDocumento(inttostr(Dados.CodUsuario),
                          datetostr(Dados.DataPagamento),
                          inttostr(Dados.LancamentoCP),
                          inttostr(Dados.NroParcela),
                          inttostr(dados.CodFormaPAgamento),
                          formatfloat('#0.00', Dados.ValorPago),
                          'DB',TipoFRMPagtoPagar, lan );
      end
      else
      begin
         if FPrincipal.BaseDados.InTransaction then
          FPrincipal.BaseDados.Rollback;
      end;
    except
      aviso(CT_BaixaInvalida);
      if FPrincipal.BaseDados.InTransaction then
        FPrincipal.BaseDados.Rollback;
    end;
end;

{***************** retorno da forma de pagamento ***************************** }
procedure TFItensCaixa.EFormaPagtoPagarRetorno(Retorno1, Retorno2: String);
begin
  if retorno1 <> '' then
  begin
    TipoFRMPagtoPagar := Retorno1;
    FlagFRMPagar := retorno2;
  end;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           contas a receber
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{ ***** RETORNO PARA CARREGAR A CONTA A RECEBER ***** }
procedure TFItensCaixa.ReceberRetorno(Retorno1,
  Retorno2: String);
begin
  if (Retorno1 <> '') then
    CarregaBaixaParcelaReceber(StrToInt(Retorno1), StrToInt(Retorno2))
  else
    FechaTabela(BaixaReceber);
  BFormaPagtoReceber.Enabled := (Retorno1 <> '');
end;


{ ***** select por número da nota ***** }
procedure TFItensCaixa.ENotaReceberSelect(Sender: TObject);
begin
  if configmodulos.academico then
  begin
    ENotaReceber.AInfo.CampoCodigo := 'I_COD_MAT';
    EnotaReceber.AInfo.Nome1 := 'Contrato';
    ENotaReceber.ASelectValida.Clear;
    ENotaReceber.ASelectValida.Add(' Select C.c_nom_CLI, CPM.I_LAN_REC, CPM.I_NRO_PAR, CP.I_COD_MAT from CadContasaReceber CP key join MovContasAReceber CPM, CadClientes C ' +
                                   ' where CP.I_COD_CLI = C.I_COD_CLI ' +
                                   ' AND CP.I_EMP_FIL = ' + IntToStr(varia.CodigoEmpFil) +
                                   ' AND CPM.D_DAT_PAG IS NULL ' +
                                   ' and isnull(CPM.C_DUP_CAN, ''N'') = ''N'' ' +
                                   ' and CP.I_COD_MAT = @');
    ENotaReceber.ASelectLocaliza.Clear;
    ENotaReceber.ASelectLocaliza.Add(' Select CPM.I_LAN_REC, CPM.I_NRO_PAR, CP.I_COD_MAT, C.C_NOM_CLI, C.I_COD_CLI ' +
                                     ' from CadContasaReceber CP key join MovContasAReceber CPM, CadClientes C  ' +
                                     ' where CP.I_EMP_FIL = ' + IntTostr(varia.CodigoEmpFil) +
                                     ' AND CPM.D_DAT_PAG IS NULL ' +
                                     ' and isnull(CPM.C_DUP_CAN, ''N'') = ''N'' ' +
                                     ' and CP.I_COD_CLI = C.I_COD_CLI and c_nom_CLI like ''@%''' +
                                     ' and not CP.I_COD_MAT is null ' );
  end
  else
    begin
      ENotaReceber.ASelectValida.Clear;
      ENotaReceber.ASelectValida.Add(' Select C.c_nom_CLI, CPM.I_LAN_REC, CPM.I_NRO_PAR from CadContasaReceber CP key join MovContasAReceber CPM, CadClientes C ' +
                                     ' where CP.I_COD_CLI = C.I_COD_CLI ' +
                                     ' AND CP.I_EMP_FIL = ' + IntToStr(varia.CodigoEmpFil) +
                                     ' AND CPM.D_DAT_PAG IS NULL ' +
                                     ' and isnull(CPM.C_DUP_CAN, ''N'') = ''N'' ' +
                                     ' and CP.I_NRO_NOT = @');
      ENotaReceber.ASelectLocaliza.Clear;
      ENotaReceber.ASelectLocaliza.Add(' Select CPM.I_LAN_REC, CPM.I_NRO_PAR, CP.I_NRO_NOT, C.C_NOM_CLI, C.I_COD_CLI ' +
                                       ' from CadContasaReceber CP key join MovContasAReceber CPM, CadClientes C  ' +
                                       ' where CP.I_EMP_FIL = ' + IntTostr(varia.CodigoEmpFil) +
                                       ' AND CPM.D_DAT_PAG IS NULL ' +
                                       ' and isnull(CPM.C_DUP_CAN, ''N'') = ''N'' ' +
                                       ' and CP.I_COD_CLI = C.I_COD_CLI and c_nom_CLI like ''@%''' +
                                       ' and not CP.I_NRO_NOT is null ' );
    end;
end;

{ ***** select por duplicata ***** }
procedure TFItensCaixa.EDuplicataReceberSelect(Sender: TObject);
begin
  if configmodulos.academico then
  begin
      EduplicataReceber.AInfo.Nome3 := 'Contrato';
      EduplicataReceber.AInfo.CampoMostra3 := 'I_COD_MAT';
      EDuplicataReceber.ASelectValida.Clear;
      EDuplicataReceber.ASelectValida.Add(' Select MCR.I_EMP_FIL,MCR.I_LAN_REC, C.C_NOM_CLI, CR.I_COD_MAT, MCR.I_NRO_PAR ' +
                                          ' from MovContasaReceber as MCR Key join CadContasAReceber as CR, CadClientes as C' +
                                          ' where CR.I_COD_CLI = C.I_COD_CLI ' +
                                          ' and MCR.I_EMP_FIL = ' + IntTostr(varia.CodigoEmpFil) +
                                          ' and MCR.D_DAT_PAG IS NULL ' + // CONTA NÃO FOI RECEBIDA
                                          ' and isnull(MCR.C_DUP_CAN, ''N'') = ''N'' ');
                                          //' and C_NRO_DUP = ''@''');
      EDuplicataReceber.ASelectLocaliza.Clear;
      EDuplicataReceber.ASelectLocaliza.Add('Select MCR.I_EMP_FIL,MCR.I_LAN_REC, C.C_NOM_CLI, CR.I_COD_MAT, MCR.C_NRO_DUP, MCR.I_NRO_PAR ' +
                                            ' from MovContasaReceber as MCR Key join CadContasAReceber as CR, CadClientes as C' +
                                            ' where CR.I_COD_CLI = C.I_COD_CLI and C.C_TIP_CAD <> ''F''' +
                                            ' and MCR.I_EMP_FIL = ' + IntTostr(varia.CodigoEmpFil) +
                                            ' and MCR.D_DAT_PAG IS NULL ' + // CONTA NÃO FOI RECEBIDA
                                            ' and isnull(MCR.C_DUP_CAN, ''N'') = ''N'' ');
                                            //' and MCR.C_NRO_DUP like ''@%''' );
  end
  else
    begin
      EDuplicataReceber.ASelectValida.Clear;
      EDuplicataReceber.ASelectValida.Add(' Select MCR.I_EMP_FIL,MCR.I_LAN_REC, C.C_NOM_CLI, CR.I_NRO_NOT, MCR.I_NRO_PAR ' +
                                          ' from MovContasaReceber as MCR Key join CadContasAReceber as CR, CadClientes as C' +
                                          ' where CR.I_COD_CLI = C.I_COD_CLI ' +
                                          ' and MCR.I_EMP_FIL = ' + IntTostr(varia.CodigoEmpFil) +
                                          ' and MCR.D_DAT_PAG IS NULL ' + // CONTA NÃO FOI RECEBIDA
                                          ' and isnull(MCR.C_DUP_CAN, ''N'') = ''N'' ' +
                                          ' and C_NRO_DUP = ''@''');
      EDuplicataReceber.ASelectLocaliza.Clear;
      EDuplicataReceber.ASelectLocaliza.Add('Select MCR.I_EMP_FIL,MCR.I_LAN_REC, C.C_NOM_CLI, CR.I_NRO_NOT, MCR.C_NRO_DUP, MCR.I_NRO_PAR ' +
                                            ' from MovContasaReceber as MCR Key join CadContasAReceber as CR, CadClientes as C' +
                                            ' where CR.I_COD_CLI = C.I_COD_CLI and C.C_TIP_CAD <> ''F''' +
                                            ' and MCR.I_EMP_FIL = ' + IntTostr(varia.CodigoEmpFil) +
                                            ' and MCR.D_DAT_PAG IS NULL ' + // CONTA NÃO FOI RECEBIDA
                                            ' and isnull(MCR.C_DUP_CAN, ''N'') = ''N'' ' +
                                            ' and MCR.C_NRO_DUP like ''@%''' );
    end;
end;

{************** select da ordem de recebimento ****************************** }
procedure TFItensCaixa.EOrdemReceberSelect(Sender: TObject);
begin
  EOrdemReceber.ASelectValida.Clear;
  EOrdemReceber.ASelectValida.Add(' Select C.c_nom_CLI, CPM.I_LAN_REC, CPM.I_NRO_PAR from CadContasaReceber CP key join MovContasAReceber CPM, CadClientes C ' +
                                  ' where CP.I_COD_CLI = C.I_COD_CLI ' +
                                  ' AND CP.I_EMP_FIL = ' + IntToStr(varia.CodigoEmpFil) +
                                  ' AND CPM.D_DAT_PAG IS NULL ' +
                                  ' and isnull(CPM.C_DUP_CAN, ''N'') = ''N'' ' +
                                  ' and CPM.I_LAN_REC = @');
  EOrdemReceber.ASelectLocaliza.Clear;
  EOrdemReceber.ASelectLocaliza.Add(' Select CPM.I_LAN_REC, CPM.I_NRO_PAR, CP.I_NRO_NOT, C.C_NOM_CLI, C.I_COD_CLI ' +
                                    ' from CadContasaReceber CP key join MovContasAReceber CPM, CadClientes C  ' +
                                    ' where CP.I_EMP_FIL = ' + IntTostr(varia.CodigoEmpFil) +
                                    ' AND CPM.D_DAT_PAG IS NULL ' +
                                    ' and isnull(CPM.C_DUP_CAN, ''N'') = ''N'' ' +
                                    ' and CP.I_COD_CLI = C.I_COD_CLI and c_nom_CLI like ''@%''' );
end;

{************** select que localiza por cliente ***************************** }
procedure TFItensCaixa.EClienteReceberSelect(Sender: TObject);
begin
  (sender as TEditLocaliza).ASelectValida.Clear;
  (sender as TEditLocaliza).ASelectValida.Add( ' select cad.i_lan_rec, mov.i_nro_par, cli.i_cod_cli, cli.c_nom_cli, cad.i_nro_not, mov.n_vlr_par ' +
                                     ' from CadClientes as cli, ' +
                                     ' CadContasAReceber as cad key join MovcontasaReceber as mov' +
                                     ' where cli.I_COD_CLI = @ ' +
                                     ' and cad.i_cod_cli = cli.i_cod_cli ' +
                                     ' AND Mov.D_DAT_PAG IS NULL ' +
                                     ' and isnull(Mov.C_DUP_CAN, ''N'') = ''N'' '  );
  (sender as TEditLocaliza).ASelectLocaliza.Clear;
  (sender as TEditLocaliza).ASelectLocaliza.Add(' select cad.i_lan_rec, mov.i_nro_par, cli.i_cod_cli, cli.c_nom_cli, cad.i_nro_not, mov.n_vlr_par ' +
                                      ' from CadClientes as cli, ' +
                                      ' CadContasAReceber as cad key join MovcontasaReceber as mov' +
                                      ' where cli.c_nom_cli like ''@%'' ' +
                                      ' and cad.i_cod_cli = cli.i_cod_cli ' +
                                      ' AND Mov.D_DAT_PAG IS NULL ' +
                                      ' and isnull(Mov.C_DUP_CAN, ''N'') = ''N'' '  );
end;

{ ***** limpa os edits do conta a receber ***** }
procedure TFItensCaixa.LimpaEditsReceber;
begin
  LAtrazoReceber.Caption := '';
  EFormaPagtoReceber.Text := '';
  EFormaPagtoReceber.Atualiza;
  EReceberValor.AValor := 0;
  ERecebidoValor.AValor := 0;
  EDescontoReceber.AValor := 0;
  EAcrescimoReceber.AValor := 0;
  ERecebidoValor.AValor := 0;
  EReceberValor.AValor := 0;
  EReceberAdicionais.AValor := 0;
  EReceberTroco.AValor := 0;
  MObsReceber.lines.clear;
  LdiasReceber.Caption := '';
  EDuplicataReceber.Clear;
  FechaTabela(BaixaReceber);
  ENotaReceber.Text := '';
  EOrdemReceber.text := '';
  EDuplicataReceber.Text := '';
end;

{*************** calcula adicionais ****************************************** }
procedure TFItensCaixa.BAdicionaisClick(Sender: TObject);
begin
  FAdicionais := TFAdicionais.CriarSDI(self,'', FPrincipal.VerificaPermisao('FAdicionais'));
  if FAdicionais.CarregaAdicional( BaixaReceberI_LAN_REC.AsInteger, BaixaReceberI_NRO_PAR.AsInteger) > 0 then // Soma os valores novamente, pois provavelmente foram alterados.
    EReceberAdicionais.AValor := CR.SomaValorReceber( BaixaReceberI_LAN_REC.AsInteger, BaixaReceberI_NRO_PAR.AsInteger)
  else
    EReceberAdicionais.AValor := 0;
end;

{********************** define o tipo de pesquisa ************************** }
procedure TFItensCaixa.CPesquisaReceberChange(Sender: TObject);
begin
  NPesquisaReceber.PageIndex := CPesquisaReceber.ItemIndex;
  LimpaEditsReceber;
end;

{***********o valor recebido naum pode ser menor que o pago ***************** }
procedure TFItensCaixa.ERecebidoValorExit(Sender: TObject);
begin
  if (ERecebidoValor.AValor < EReceberValor.AValor) then
  begin
    ERecebidoValor.AValor := EReceberValor.AValor;
    Aviso(CT_Valor_Invalido);
  end;
end;

{******************** valor total da  parcela ***************************** }
procedure TFItensCaixa.EDescontoReceberChange(Sender: TObject);
begin
  EReceberValor.AValor := ValorParcelaReceber + EAcrescimoReceber.AValor + EReceberAdicionais.AValor - EDescontoReceber.AValor;
  ERecebidoValor.AValor := EReceberValor.AValor;
end;

{******************* calcula o valor a receber ******************************* }
procedure TFItensCaixa.CalculaValoresReceber;
var
  multa, mora, juro, desconto : double;
  Moedas : TFuncoesMoedas;
  uni : string;
begin
  ValorParcelaReceber := baixaReceberN_VLR_PAR.AsCurrency;

  MObsReceber.Lines.Clear;
  MObsReceber.Lines.Add(BaixaReceberL_OBS_REC.AsString);
  DataReceber.Text := DateToStr(date);
  EFormaPagtoReceber.Text := BaixaReceberI_COD_FRM.AsString;
  EFormaPagtoReceber.Atualiza;

  // verifica moeda e converte para o pagamento
  if BaixaReceberI_cod_moe.AsInteger <> varia.MoedaBase then
  begin
     Moedas := TFuncoesMoedas.criar(self, FPrincipal.BaseDados);
     ValorParcelaReceber := Moedas.ConverteValorParaMoedaBase(uni, BaixaReceberI_COD_MOE.AsInteger, date, baixaReceberN_VLR_PAR.AsCurrency);
     MObsReceber.Lines.Text := MObsReceber.Lines.Text +  '  - Valor original ' + uni + ' ' + FormatFloat(varia.MascaraValor, baixaReceberN_VLR_PAR.AsCurrency);
     Moedas.Free;
  end;

  multa := BaixaReceberN_PER_MUL.AsCurrency;
  mora := BaixaReceberN_PER_MOR.AsCurrency;
  juro := BaixaReceberN_PER_JUR.AsCurrency;
  desconto := BaixaReceberN_DES_VEN.AsCurrency;

  LdiasReceber.Caption := InTToStr(CR.CalculaJuros( multa, mora, juro, desconto,
                                   BaixaReceberD_DAT_VEN.AsDateTime, date,
                                   ValorParcelaReceber ));
  EReceberAdicionais.AValor := BaixaReceberN_VLR_ADI.AsCurrency;
  EAcrescimoReceber.Avalor := multa + mora + juro;
  EDescontoReceber.AValor := desconto;
  EReceberValor.AValor := ValorParcelaReceber + multa + mora + BaixaReceberN_VLR_ADI.AsCurrency + Juro - desconto;
  ERecebidoValor.AValor := EReceberValor.AValor;
end;

{******************* carrega a baixa da parcela ***************************** }
function TFItensCaixa.CarregaBaixaParcelaReceber( numeroLancamento, numeroparcela : integer) : Boolean;
begin
  Result := true;

  if numeroparcela <> 0 then
     CR.LocalizaParcelaAberta(BaixaReceber,numerolancamento, numeroparcela)
  else
    CR.LocalizaParcelasAbertas(Baixareceber,numerolancamento,'D_DAT_VEN');

  CR.LocalizaContaCR( CadBaixaReceber, numeroLancamento,varia.CodigoEmpFil);

  if not baixareceber.Eof then
  begin
    BAdicionais.Enabled := True;
    CR.IgualarValoresAdicionais(BaixareceberI_LAN_REC.AsInteger, BaixareceberI_NRO_PAR.AsInteger);
    CalculaValoresReceber;
  end
  else
  begin
    BAdicionais.Enabled := False;
    aviso(CT_TodaParcelasPagas);
    result := false;
  end;
end;

{********************** valor recebido  - troco ***************************** }
procedure TFItensCaixa.ERecebidoValorChange(Sender: TObject);
begin
  EReceberTroco.AValor := (ERecebidoValor.AValor - EReceberValor.AValor);
end;

{*************** confirma a baixa ******************************************** }
procedure TFItensCaixa.BaixaContaReceber;
var
  Dados : TDadosBaixaCR;
  lan : integer;
begin

    AcionaGaveta(EFormaPagtoReceber.text);

    try
      if not FPrincipal.BaseDados.InTransaction then
        FPrincipal.BaseDados.StartTransaction;

      Dados := TDadosBaixaCR.Create;
      Dados.LancamentoCR := BaixaReceberI_LAN_REC.AsInteger;
      lan := BaixaReceberI_LAN_REC.AsInteger;
      Dados.NroParcela := BaixaReceberI_NRO_PAR.AsInteger;
      Dados.CodUsuario := varia.CodigoUsuario;
      Dados.NroParcelaMae := BaixaReceberI_PAR_MAE.AsInteger;
      Dados.CodMoedaAtual := BaixaReceberI_COD_MOE.AsInteger;
      Dados.DataPagamento := StrToDate(DataReceber.Text);
      Dados.ValorAdicionais := EReceberAdicionais.AValor;
      Dados.ValorDesconto := EDescontoReceber.AValor;
      Dados.valorAcrescimo := EAcrescimoReceber.AValor;
      Dados.ValorPago := EReceberValor.AValor;
      Dados.Observacao := MObsReceber.Lines.Text;
      Dados.VerificarCaixa := true;
      Dados.TipoFrmPagto := TipoFRMPagtoReceber;
      Dados.LancarBanco := true;
      dados.PlanoConta := cadBaixaReceber.FieldByName('C_CLA_PLA').AsString;
      dados.CodFormaPAgamento := strToInt(EFormaPagtoReceber.text);
      dados.VerficarFormaPagamento := true;
      dados.TrocoCaixa := EReceberTroco.AValor;
      dados.ValorTotalAserPago := ValorParcelaReceber +  Dados.valorAcrescimo - Dados.ValorDesconto + Dados.ValorAdicionais;
      if config.JurosMultaDoDia then
      begin
         Dados.Mora := varia.Mora;
         Dados.Juro := varia.Juro;
         Dados.Multa := varia.Multa;
      end
      else
      begin
         Dados.multa := BaixaReceberN_PER_MUL.AsCurrency;
         Dados.mora := BaixaReceberN_PER_MOR.AsCurrency;
         Dados.juro := BaixaReceberN_PER_JUR.AsCurrency;
      end;

      if CR.BaixaContaAReceber( dados ) then
      begin
        Dados.Free;
        if FPrincipal.BaseDados.InTransaction then
          FPrincipal.BaseDados.commit;

       // lanca no ecf
       if (UsarECF) and (FlagFRMReceber = 'C') then
          ECF.Sangria_Suprimento( EReceberValor.AValor, false );
          LimpaEditsReceber;

       AutenticaDocumento(inttostr(Dados.CodUsuario),
                          datetostr(Dados.DataPagamento),
                          inttostr(Dados.LancamentoCR),
                          inttostr(Dados.NroParcelaMae),
                          inttostr(dados.CodFormaPAgamento),
                          formatfloat('#0.00', Dados.ValorPago),
                          'CR', TipoFRMPagtoReceber,
                          lan);
      end
      else
      begin
         if FPrincipal.BaseDados.InTransaction then
          FPrincipal.BaseDados.Rollback;
      end;
    except
      aviso(CT_BaixaInvalida);
      if FPrincipal.BaseDados.InTransaction then
        FPrincipal.BaseDados.Rollback;
    end;

end;

{***************** retorno da forma de pagamento ***************************** }
procedure TFItensCaixa.EFormaPagtoReceberRetorno(Retorno1,
  Retorno2: String);
begin
  if retorno1 <> '' then
  begin
    TipoFRMPagtoReceber := Retorno1;
    FlagFRMReceber := retorno2;
  end;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                   outros
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{***************** plano de conta ******************************************* }
procedure TFItensCaixa.EPlanoOutrosExit(Sender: TObject);
var
  VpfCodigo : string;
begin
  FPlanoConta := TFPlanoConta.criarSDI(Self, '', True);
  VpfCodigo := EPlanoOutros.Text;
  if not FPlanoConta.verificaCodigo(VpfCodigo, VprCreditoDebito, LPlano, false,(Sender is TSpeedButton) ) then
    EPlanoOutros.SetFocus;
  EPlanoOutros.Text := VpfCodigo;
end;

{********************* plano de conta **************************************** }
procedure TFItensCaixa.EPlanoOutrosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 114 then
    EPlanoOutrosExit(BPlano);
end;

{*************** retorno da forma de pagamento ******************************* }
procedure TFItensCaixa.EFormaPagtoOutrosRetorno(Retorno1,
  Retorno2: String);
begin
  if retorno1 <> '' then
    tipoFRMpagtoOutros := retorno1;
end;

{****************** Lancamento do CP pelo Outros **************************** }
procedure  TFItensCaixa.lancamentoCP;
var
  Dado : TDadosNovaContaCP;
  ValorFinal, Valorpago : Double;
  FormaPAgto : Integer;
begin
  if not FPrincipal.BaseDados.InTransaction then
    FPrincipal.BaseDados.StartTransaction;

  AcionaGaveta(EFormaPagtoOutros.text);

  try
    TTempo.execute('Criando as Parcelas...');
    Dado := TDadosNovaContaCP.Create;
    Dado.CodEmpFil := Varia.CodigoEmpFil;
    Dado.NroNota := trunc(ENotaOutro.AValor);
    Dado.SeqNota := 0;
    Dado.CodFornecedor := StrToInt(EFornecedor.text);
    Dado.CodFrmPagto :=  StrToInt(EFormaPagtoOutros.Text);
    Dado.CodMoeda := varia.MoedaBase;
    Dado.CodUsuario := varia.CodigoUsuario;
    Dado.DataMovto := date;
    dado.DataBaixa := date;
    Dado.DataEmissao := date;
    Dado.PlanoConta := EPlanoOutros.text;
    Dado.PathFoto := '';
    Dado.NumeroParcela := 1;
    Dado.ValorParcela := EOutroPagoRecebido.AValor;
    Dado.QtdDiasPriVen := 0;
    Dado.QtdDiasDemaisVen := 30;
    Dado.PercentualDescAcr := 0;
    Dado.VerificarCaixa := true;//false;
    Dado.BaixarConta := true;
    Dado.MostrarParcelas :=  false;
    Dado.TipoFrmPAgto := tipoFRMpagtoOutros;
    Dado.CodDespesaFixa := 0;
    Dado.ContaVinculada := 0;
    Dado.ParcelaVinculada := 0;
    LancamentoOutros := CP.CriaContaPagar( dado,  ValorFinal, Valorpago, FormaPAgto, false );
    dado.free;
    TTempo.fecha;

    AutenticaDocumento(inttostr(Dado.CodUsuario),
                          datetostr(Dado.DataBaixa),
                          inttostr(Dado.NroNota),
                          inttostr(Dado.NumeroParcela),
                          inttostr(dado.CodFrmPagto),
                          formatfloat('#0.00', Dado.ValorParcela),
                          'DB', tipoFRMpagtoOutros, 0);

  if FPrincipal.BaseDados.InTransaction then
    FPrincipal.BaseDados.Commit;

  except
   Aviso(CT_ErroConta);
   if FPrincipal.BaseDados.InTransaction then
     FPrincipal.BaseDados.Rollback;
  end;
end;

{****************** Lancamento do CR pelo Outros **************************** }
procedure TFItensCaixa.lancamentoCR;
var
  Dado : TDadosNovaContaCR;
  CodFrmPagto : Integer;
  Troco, ValorTotal : Double;
begin
  if not FPrincipal.BaseDados.InTransaction then
    FPrincipal.BaseDados.StartTransaction;

  AcionaGaveta(EFormaPagtoOutros.text);

  try
    Dado := TDadosNovaContaCR.Create;
    Dado.CodEmpFil := Varia.CodigoEmpFil;
    Dado.NroNota := trunc(ENotaOutro.AValor);
    Dado.SeqNota := 0;
    Dado.CodCondicaoPgto := Varia.CondPagtoVista;
    Dado.CodCliente := StrToInt(EFornecedor.text);
    Dado.CodFrmPagto := StrToInt(EFormaPagtoOutros.Text);
    Dado.CodMoeda :=  varia.MoedaBase;
    Dado.CodUsuario := varia.CodigoUsuario;
    Dado.DataMov := date;
    Dado.DataEmissao := date;
    Dado.PlanoConta := EPlanoOutros.text;
    Dado.ValorTotal := EOutroValor.AValor;
    Dado.PercentualDescAcr := 0;
    Dado.VerificarCaixa := true;//false;
    Dado.BaixarConta := true;
    Dado.DataBaixa := date;
    Dado.MostrarParcelas := false;
    Dado.MostrarTelaCaixa := true;//false;
    Dado.TipoFrmPAgto :=  tipoFRMpagtoOutros;
    Dado.GerarComissao := false;
    Dado.ValorPro :=  nil;
    Dado.PercPro :=  nil;
//    Dado.CodVendedor := 0;                                     /
// aqui   Dado.PercComissaoPro := 0;
//    Dado.ValorComPro := 0;
//    Dado.PercComissaoServ := 0;
//    Dado.ValorComServ := 0;
//    Dado.TipoComissao := 0; // somente direta
    LancamentoOutros := CR.CriaContaReceber( dado, ValorTotal, troco, CodFrmPagto, false );
    if IntToStr(CodFrmPagto) <> EFormaPagtoOutros.Text then
    begin
      EFormaPagtoOutros.Text := IntToStr(CodFrmPagto);
      EFormaPagtoOutros.Atualiza;
    end;

    AutenticaDocumento(inttostr(Dado.CodUsuario),
                          datetostr(Dado.DataBaixa),
                          inttostr(Dado.NroNota),
                          inttostr(1),
                          inttostr(dado.CodFrmPagto),
                          formatfloat('#0.00', Dado.ValorTotal),
                          'CR', tipoFRMpagtoOutros, LancamentoOutros);
    Dado.Destroy;

  if FPrincipal.BaseDados.InTransaction then
    FPrincipal.BaseDados.Commit;

  except
   Aviso(CT_ErroConta);
   if FPrincipal.BaseDados.InTransaction then
     FPrincipal.BaseDados.Rollback;
  end;

end;

{**************** limpa edits de outros ************************************** }
procedure TFItensCaixa.limpaEditsOutro;
begin
  EFormaPagtoOutros.Text := '';
  EFormaPagtoOutros.Atualiza;
  EFornecedor.Text := '';
  EFornecedor.Atualiza;
  EPlanoOutros.Text := '';
  ENotaOutro.AValor := 0;
  LPlano.Caption := '';
  EOutroValor.AValor := 0;
  EOutroPagoRecebido.AValor := 0;
end;


{***************Troca cheque por dinheiro *********************************** }
procedure TFItensCaixa.TrocaChequeDinheiro;
begin
  if (EditLocaliza2.Text <> EditLocaliza3.Text) then
  begin
    AcionaGaveta(EFormaPagtoReceber.text);
    Caixa.LancaItemCaixa( 'D','', date,
            StrToInt(ETipoOperacao.Text),
            StrToInt(EditLocaliza2.Text),
            0, 1,
            Caixa.SequencialGeralAberto(varia.CaixaPadrao),
            Caixa.SequencialParcialAberto(varia.CaixaPadrao),
            numerico3.AValor,
            0,
            numerico3.AValor, 0, 'N');
    Caixa.LancaItemCaixa( 'C', '',date,
            StrToInt(ETipoOperacao.Text),
            StrToInt(EditLocaliza3.Text),
            0, 1,
            Caixa.SequencialGeralAberto(varia.CaixaPadrao),
            Caixa.SequencialParcialAberto(varia.CaixaPadrao),
            numerico3.AValor,
            0,
            numerico3.AValor, 0, 'N');
    EditLocaliza2.Text := '';
    EditLocaliza2.Atualiza;
    EditLocaliza3.Text := '';
    EditLocaliza3.Atualiza;
    numerico3.AValor := 0;
  end
  else
    aviso('Formas de pagamento iguais !');
end;

{********************* abre tabela para mudanca de forma ********************}
procedure TFItensCaixa.AbreMudaForma;
begin
  LimpaSQLTabela(MudaForma);
  AdicionaSQLTabela(MudaForma, ' Select ' +
                               ' cad.i_nro_not, cli.c_nom_cli, frm.c_nom_frm, mov.n_vlr_par, ' +
                               ' cad.i_cod_cli, mov.i_cod_frm, mov.i_nro_par, cad.i_lan_rec, cad.d_dat_emi, frm.c_fla_tip,C_FLA_BCR ' +
                               ' from cadcontasareceber cad key join movcontasareceber mov, ' +
                               ' cadclientes cli, cadformaspagamento frm ' +
                               ' where cad.i_emp_fil = ' + Inttostr(varia.CodigoEmpFil) +
                               ' and cad.d_dat_emi >=  ' + SQLTextoDataAAAAMMMDD(Data1.DateTime) +
                               ' and mov.d_dat_pag is null ' +
                               ' and mov.C_DUP_CAN = ''N'' ' +
                               ' and cad.i_cod_cli = cli.i_cod_cli ' +
                               ' and mov.i_cod_frm = frm.i_cod_frm ');
  if NFiscal.AValor <> 0 then
    AdicionaSQLTabela(MudaForma, ' and cad.i_nro_not = ' + inttostr(trunc(NFiscal.AValor)));
  if EditLocaliza4.Text <> '' then
    AdicionaSQLTabela(MudaForma, ' and cad.i_cod_cli = ' + EditLocaliza4.Text);
  AbreTabela(MudaForma);
end;

{**************** altera a forma de pagamento ****************************** }
procedure TFItensCaixa.AlteraFormaPagto;
var
   formaPgto : integer;
begin
  if not MudaForma.eof then
  begin
      if MudaFormaC_FLA_BCR.AsString = 'C' then
        Cr.EstornaCaixaFormaPagamento(MudaFormaI_COD_FRM.AsInteger,
                                      MudaFormaI_LAN_REC.AsInteger,
                                      MudaFormaI_NRO_PAR.AsInteger,
                                      MudaFormaI_cod_cli.asinteger,
                                      MudaFormaN_VLR_PAR.AsCurrency);
      FFormaPagtoCR1 := TFFormaPagtoCR1.CriarSDI(application, '', true);
      formaPgto := FFormaPagtoCR1.FormaPagamentoParcela( MudaFormaI_LAN_REC.AsInteger, MudaFormaI_NRO_PAR.AsInteger,
                                           MudaFormaI_COD_FRM.AsInteger,
                                           MudaFormaN_VLR_PAR.AsCurrency,
                                           MudaFormaN_VLR_PAR.AsCurrency);
      Caixa.LocalizaFormaPagamento(aux, formaPgto);
      if aux.fieldByName('C_FLA_BCR').AsString = 'C' then
        Cr.LancaItemCaixaFormaPagamento(formaPgto,
                                        MudaFormaI_LAN_REC.AsInteger,
                                        MudaFormaI_NRO_PAR.AsInteger,
                                        MudaFormaI_cod_cli.asinteger,
                                        MudaFormaI_NRO_NOT.asInteger,
                                        MudaFormaD_DAT_EMI.asDateTime,
                                        MudaFormaN_VLR_PAR.AsCurrency);
      AtualizaSQLTabela(MudaForma);
  end;
end;

{************************ Cadastro de fornecedores ************************* }
procedure TFItensCaixa.EFornecedorCadastrar(Sender: TObject);
begin
  FNovoCliente := TFNovoCliente.CriarSDI(application,'',true);
  FNovoCliente.CadClientes.Insert;
  FNovoCliente.ShowModal;
  Localiza.AtualizaConsulta;
end;

{***************** select de cliente dos outros ***************************** }
procedure TFItensCaixa.EFornecedorSelect(Sender: TObject);
begin
EFornecedor.ASelectValida.Clear;
EFornecedor.ASelectValida.Add( ' select * from CadClientes ' +
                               ' where I_COD_CLI = @ ' );
EFornecedor.ASelectLocaliza.Clear;
EFornecedor.ASelectLocaliza.Add(' Select * from CadClientes '  +
                                ' where c_nom_cli like ''@%'' ');

  if VprCreditoDebito = 'C' then
  begin
    EFornecedor.ASelectValida.Add(' and c_tip_cad <> ''F'' ');
    EFornecedor.ASelectLocaliza.Add(' and  c_tip_cad <> ''F'' ' );
  end
  else
  begin
    EFornecedor.ASelectValida.Add(' and c_tip_cad <> ''C'' ');
    EFornecedor.ASelectLocaliza.Add(' and  c_tip_cad <> ''C'' ' );
  end;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Diversos
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{************** select do tipo de operacao *********************************** }
procedure TFItensCaixa.ETipoOperacaoSelect(Sender: TObject);
begin
    Caixa.LocalizaCadCaixa(CadCaixa, varia.caixapadrao);
    ETipoOperacao.ASelectLocaliza.Clear;
    ETipoOperacao.ASelectLocaliza.Add( ' SELECT * FROM CAD_TIPO_OPERA ' +
                                       ' WHERE DES_OPERACAO LIKE ''@%'' ' +
                                       ' AND FLA_TIPO <> ''S'' ' +
                                       ' AND ( COD_OPERACAO <> ' + IntToStr(Varia.CodOpeEstornaCaixaCR) +
                                       ' AND COD_OPERACAO <> ' + IntToStr(Varia.CodOpeEstornaCaixaCP) + ')' );

    ETipoOperacao.ASelectValida.Clear;
    ETipoOperacao.ASelectValida.Add(' SELECT * FROM CAD_TIPO_OPERA ' +
                                    ' WHERE COD_OPERACAO = @ ' +
                                    ' AND FLA_TIPO <> ''S'' ' +
                                    ' AND ( COD_OPERACAO <> ' + IntToStr(Varia.CodOpeEstornaCaixaCR) +
                                    ' AND COD_OPERACAO <> ' + IntToStr(Varia.CodOpeEstornaCaixaCP) + ')' );


  // Baixar conta a pagar
    if (not ConfigModulos.ContasAPagar) or
       (CadCaixa.fieldByname('fla_pag_pag').AsString = 'S') then
    begin
      ETipoOperacao.ASelectValida.Add(' AND FLA_TIPO <> ''P'' ');
      ETipoOperacao.ASelectLocaliza.Add(' AND FLA_TIPO <> ''P'' ');
    end;

  // Baixar conta a receber
    if (not ConfigModulos.ContasAReceber) or
       (CadCaixa.fieldByname('fla_rec_rec').AsString = 'S') then
    begin
      ETipoOperacao.ASelectLocaliza.Add(' AND FLA_TIPO <> ''R'' ');
      ETipoOperacao.ASelectValida.Add(' AND FLA_TIPO <> ''R'' ');
    end;

  // cadastrar conta a pagar
    if (not ConfigModulos.ContasAPagar) or
       (CadCaixa.fieldByname('fla_cad_pag').AsString = 'S') then
    begin
      ETipoOperacao.ASelectValida.Add(' and fla_tipo || credito_debito  <> ''OD'' ');
      ETipoOperacao.ASelectLocaliza.Add(' and fla_tipo || credito_debito  <> ''OD'' ');
    end;

  // cadastrar conta a receber
    if (not ConfigModulos.ContasAReceber) or
       (CadCaixa.fieldByname('fla_cad_rec').AsString = 'S') then
    begin
      ETipoOperacao.ASelectValida.Add(' and fla_tipo || credito_debito  <> ''OC'' ');
      ETipoOperacao.ASelectLocaliza.Add(' and fla_tipo || credito_debito  <> ''OC'' ');
    end;

    if (not ConfigModulos.ContasAPagar) or
       (CadCaixa.fieldByname('fla_cad_pag').AsString = 'S') then
    begin
      ETipoOperacao.ASelectValida.Add(' and fla_tipo || credito_debito  <> ''OD'' ');
      ETipoOperacao.ASelectLocaliza.Add(' and fla_tipo || credito_debito  <> ''OD'' ');
    end;

end;                                   // cadastrar conta a pagar

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                        EFETUA OPERAÇÃO
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************** efetua a operacao de caixa ****************************** }
procedure TFItensCaixa.BConfirmaOperacaoClick(Sender: TObject);
begin
  TTempo.Execute('Efetuando Operação ... ');
  case NItensCaixa.PageIndex of
    0 : begin BaixaContaApagar end;// CONTA A PAGAR;
    1 : begin BaixaContaReceber end;// CONTA A RECEBER;
    2 : begin  // OUTROS CP,  CR
          if VprCreditoDebito = 'D'  then
            lancamentoCP
          else
            lancamentoCR;
          LancamentoOutros := 0;
          limpaEditsOutro;
        end;
    3 : begin  // Recibo
          LancamentoOutros := 0;
          limpaEditsOutro;
        end;
    4 : begin
          TrocaChequeDinheiro;
        end;
  end;

  TTempo.Fecha;
  ETipoOperacao.SetFocus;
end;

{****************** Autentica Documento ************************************** }
procedure TFItensCaixa.AutenticaDocumento(usuario, data, doc, parcela, formapagto, valor, operacao, tipo : string; lan : integer);
var
  a : integer;
begin
  a := 0;
  Case varia.TipoImpressoraAUT of
    0 : begin
        end;
        //ecf.Autenticacao;
    1 : begin
          AUT.AbrePorta;
          if Aut.VerificaImpressora then
          begin
            Aut.ImprimeFormato(usuario
                               + ' ' + data
                               + ' ' + doc
                               + ' ' + parcela
                               + ' ' + formapagto
                               + ' ' + Valor
                               + ' ' + operacao);
            for a := 0 to varia.NumeroAutenticacao -1 do
            begin
              if confirmacao('Insira Documento para Autenticar') then
              begin
                 if Aut.DocumentoInserido then
                    Aut.Autentica(usuario
                                 + ' ' + data
                                 + ' ' + doc
                                 + ' ' + parcela
                                 + ' ' + formapagto
                                 + ' ' + Valor
                                 + ' ' + operacao);
                 if ((tipo = 'C') or (tipo = 'R')) and (VprCreditoDebito = 'C') then
                 begin
                   CR.LocalizaMOvFormas(Aux, varia.codigoempfil, lan, strtoint(parcela));
                   Aut.Autentica('Valido apos compensacao ' + 'vencimento '
                                 + datetostr(aux.fieldbyname('D_che_ven').asdatetime));
                 end;
              end;
            end;
          end;
          AUT.FecharPorta;
        end;
  end;
end;

{****************** aciona gaveta ******************************************* }
procedure TFItensCaixa.AcionaGaveta( FormaPagamento : string );
begin
   // verifica aciona gaveta
  if caixa.CaixaUsaEcf(varia.CaixaPadrao) then
    if (varia.UsarGaveta = 'S') then
    begin
      CP.LocalizaFormaPagamento( aux, StrToInt( FormaPagamento));
      if (aux.fieldByname('C_ACI_GAV').AsString = 'S') then
          ECF.AcionaGaveta;
    end;
end;

{******************* muda o estado do botao de autenticacao ***************** }
procedure  TFItensCaixa.HabilitaAutenticacao( Estado : Boolean );
begin
  if caixa.CaixaUsaEcf(varia.CaixaPadrao) then
    if (UsarECF) and (FlagFRMReceber = 'C') then
      BAutenticacao.Enabled := Estado
    else
      BAutenticacao.Enabled := false;
end;


procedure TFItensCaixa.EFormaPagtoOutrosChange(Sender: TObject);
begin
  if (EFormaPagtoOutros.Text = '') or (EFornecedor.Text = '') or ( EPlanoOutros.Text = '') or (EOutroValor.AValor = 0) then
    BConfirmaOperacao.Enabled := false
  else
    BConfirmaOperacao.Enabled := true;
  EOutroPagoRecebido.AValor := EOutroValor.AValor;
end;

procedure TFItensCaixa.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FItensCaixa.HelpContext);
end;

procedure TFItensCaixa.BitBtn2Click(Sender: TObject);
begin
  if (numerico1.text = '') or
     (EditColor2.Text = '')or
     (ECPF.Text = '') then
  begin
    Informacao('Dados Incompletos !');
  end
  else
  begin
    FReportRecibos := TFReportRecibos.CriarSDI(application,'',true);
    FReportRecibos.ImprimeRecibos(numerico1.AValor,EditColor2.text,ECPF.Text, EditColor1.text);
    numerico1.AValor := 0;
    EditColor2.Text := '';
    EditColor1.Text := 'Referênte a';
    EditLocaliza1.Text := '';
    ECPF.Text := '';
    EditLocaliza1.atualiza;
  end;
end;

procedure TFItensCaixa.numerico1Change(Sender: TObject);
begin
  if (EditColor2.Text = '') or (EditLocaliza1.Text = '') or ( EditColor1.Text = '') or (Numerico1.AValor = 0) then
    BitBtn2.Enabled := false
  else
    BitBtn2.Enabled := true;
end;

procedure TFItensCaixa.EditLocaliza2Change(Sender: TObject);
begin
  if (EditLocaliza2.Text = '') or (EditLocaliza3.Text = '') or (Numerico3.AValor = 0) then
    BConfirmaOperacao.Enabled := false
  else
    BConfirmaOperacao.Enabled := true;
end;

procedure TFItensCaixa.BitBtn1Click(Sender: TObject);
begin
  AlteraFormaPagto;
end;

procedure TFItensCaixa.NFiscalExit(Sender: TObject);
begin
  AbreMudaForma;
end;

Initialization
  RegisterClasses([TFItensCaixa]);
end.


