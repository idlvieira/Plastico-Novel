//Bibliotecas
#Include "TOTVS.ch"
#Include "FWPrintSetup.ch"
#Include "RPTDef.CH"
 
Static oSetupPrt := Nil
 
/*/{Protheus.doc} zTMSPrinter
Criação da classe Pessoa
@author Atilio
@since 06/06/2025
@version 1.0
/*/
  
Class zTMSPrinter
    //Atributos
    Data oPrint     //Objeto de impressão em FWMSPrinter
    Data cNome      //Nome do Arquivo
    Data nColRecuo  //Número em Pixels para recuo das colunas da esquerda
    Data nLinReTopo //Número em Pixels para recuo das linhas do cabeçalho
  
    //Métodos
    Method New() CONSTRUCTOR
    Method Setup()
    Method SetPaperSize()
    Method SetPortrait()
    Method SetLandscape()
    Method StartPage()
    Method EndPage()
    Method Preview()
    Method Print()
    Method Say()
    Method Line()
    Method FillRect()
    Method SayBitmap()
    Method Box()
    Method SetRecuo()
    Method SetRecuoTopo()
EndClass
 
/*/{Protheus.doc} New
Método que cria a instância com a classe
@author Atilio
@since 06/06/2025
@version 1.0
@param cNome, Caracter, Nome do relatório
/*/
  
Method New(cNome) Class zTMSPrinter
    Default cNome := "relatorio_" + dToS(Date()) + "_" + StrTran(Time(), ":", "-")
 
    //Define que não haverá recuo
    ::nColRecuo  := 0
    ::nLinReTopo := 0
 
    //Altera o atributo de nome
    ::cNome := cNome
 
    //Cria o relatório
    ::oPrint := FWMSPrinter():New(;
        ::cNome,; //cFilePrinter
        IMP_PDF,; //nDevice
        .T.,;     //lAdjustToLegacy
        ,;        //cPathInServer
        .T.,;     //lDisabeSetup
        ,;        //lTReport
        ,;        //oPrintSetup
        ,;        //cPrinter
        ,;        //lServer
        ,;        //lParam10
        ,;        //lRaw
        .T.;      //lViewPDF
    )
    ::oPrint:cPathPDF := GetTempPath()
    ::oPrint:SetResolution(72)
    ::oPrint:SetPortrait()
    ::oPrint:SetPaperSize(DMPAPER_A4)
    ::oPrint:SetMargin(0, 0, 0, 0)
 
    //Se não teve setup configurado ainda
    If ValType(oSetupPrt) == 'U'
        ::Setup()
    EndIf
Return Self
 
/*/{Protheus.doc} Setup
Método que abre a tela para selecionar a impressora
@author Atilio
@since 06/06/2025
@version 1.0
/*/
  
Method Setup() Class zTMSPrinter
    Local nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN + PD_DISABLEORIENTATION + PD_DISABLEDESTINATION
 
    //Se passar pelo método de Setup, zera a variável
    oSetupPrt := Nil
 
    //Enquanto não for confirmado, vai mostrar a tela de setup
    While ValType(oSetupPrt) == 'U'
        oSetupPrt := FWPrintSetup():New(nFlags, ::cNome)
        oSetupPrt:SetProperty(PD_PRINTTYPE   , 2)  //PDF ou LOCAL
        oSetupPrt:SetProperty(PD_ORIENTATION , 1)  //RETRATO
        oSetupPrt:SetProperty(PD_DESTINATION , 2)  //LOCAL
        oSetupPrt:SetProperty(PD_MARGIN      , {60,60,60,60})
        If oSetupPrt:Activate() != PD_OK
            oSetupPrt := Nil
        EndIf
    EndDo
 
    //Agora define no relatório
    ::oPrint:nDevice  := oSetupPrt:aOptions[PD_PRINTTYPE]
    ::oPrint:cPrinter := oSetupPrt:aOptions[PD_VALUETYPE]
Return
 
/*/{Protheus.doc} SetPaperSize
Define o tamanho da folha (A4, A3, etc)
@author Atilio
@since 06/06/2025
@version 1.0
/*/
  
Method SetPaperSize(nSize) Class zTMSPrinter
    ::oPrint:SetPaperSize(nSize)
Return
 
/*/{Protheus.doc} SetPortrait
Define a orientação do relatório como Retrato
@author Atilio
@since 06/06/2025
@version 1.0
/*/
  
Method SetPortrait() Class zTMSPrinter
    ::oPrint:SetPortrait()
Return
 
/*/{Protheus.doc} SetLandscape
Define a orientação do relatório como Paisagem
@author Atilio
@since 06/06/2025
@version 1.0
/*/
  
Method SetLandscape() Class zTMSPrinter
    ::oPrint:SetLandscape()
Return
 
/*/{Protheus.doc} StartPage
Inicia uma nova página
@author Atilio
@since 06/06/2025
@version 1.0
/*/
  
Method StartPage() Class zTMSPrinter
    ::oPrint:StartPage()
Return
 
/*/{Protheus.doc} EndPage
Encerra a página atual
@author Atilio
@since 06/06/2025
@version 1.0
/*/
  
Method EndPage() Class zTMSPrinter
    ::oPrint:EndPage()
Return
 
/*/{Protheus.doc} Preview
Visualiza o relatório
@author Atilio
@since 06/06/2025
@version 1.0
/*/
  
Method Preview() Class zTMSPrinter
    ::oPrint:Preview()
Return
 
/*/{Protheus.doc} Print
Visualiza o relatório
@author Atilio
@since 06/06/2025
@version 1.0
/*/
  
Method Print() Class zTMSPrinter
    ::oPrint:Print()
Return
 
/*/{Protheus.doc} Say
Imprime um texto no relatório
@author Atilio
@since 06/06/2025
@version 1.0
/*/
  
Method Say(nLinha, nColuna, cTexto, oFonte, nCompat1, nCorTexto, nCompat2, nAlinhamento) Class zTMSPrinter
    Local aDimensoes     := {}
    Local nLargura       := 0
    Local nAltura        := 0
    Default nAlinhamento := 0
    Default nCorTexto    := Nil
 
    //Somente se houver texto
    If ! Empty(cTexto)
        If ::nColRecuo != 0
            nColuna  := nColuna - ::nColRecuo
        EndIf
 
        If ::nLinReTopo != 0
            nLinha  := nLinha - ::nLinReTopo
        EndIf
 
        //Calcula a largura e altura conforme o tamanho do texto e a fonte
        aDimensoes := GetStringPixSize(cTexto, oFonte:Name, oFonte:nHeight, oFonte:Bold, oFonte:Italic, oFonte:Underline)
        nAltura    := aDimensoes[1] * 4
        nLargura   := aDimensoes[2] * 4
 
        //Se for alinhamento a direita
        If nAlinhamento == 1
            nColuna := nColuna - nLargura
 
        //Se for alinhamento centralizado
        ElseIf nAlinhamento == 2
            nColuna := nColuna - (nLargura / 2)
        EndIf
 
        //Imprime o Texto
        ::oPrint:SayAlign(nLinha, nColuna, cTexto, oFonte, nLargura, nAltura, nCorTexto, nAlinhamento, /*nAlignVert*/)
    EndIf
Return
 
/*/{Protheus.doc} Line
Imprime uma linha no relatório
@author Atilio
@since 06/06/2025
@version 1.0
/*/
  
Method Line(nLinhaIni, nColunaIni, nLinhaFin, nColunaFin) Class zTMSPrinter
    If ::nColRecuo != 0
        nColunaIni  := nColunaIni - ::nColRecuo
        nColunaFin  := nColunaFin - ::nColRecuo
    EndIf
    If ::nLinReTopo != 0
        nLinhaIni  := nLinhaIni - ::nLinReTopo
        nLinhaFin  := nLinhaFin - ::nLinReTopo
    EndIf
    ::oPrint:Line(nLinhaIni, nColunaIni, nLinhaFin, nColunaFin, /*nColor*/, /*cPixel*/) 
Return
 
/*/{Protheus.doc} FillRect
Pinta um retângulo no relatório
@author Atilio
@since 06/06/2025
@version 1.0
/*/
  
Method FillRect(aCoordenadas, oBrush) Class zTMSPrinter
    If ::nColRecuo != 0
        aCoordenadas[2] := aCoordenadas[2] - ::nColRecuo
        aCoordenadas[4] := aCoordenadas[4] - ::nColRecuo
    EndIf
    If ::nLinReTopo != 0
        aCoordenadas[1] := aCoordenadas[1] - ::nLinReTopo
        aCoordenadas[3] := aCoordenadas[3] - ::nLinReTopo
    EndIf
    ::oPrint:FillRect(aCoordenadas, oBrush, /*cPixel*/)
Return
 
/*/{Protheus.doc} SayBitmap
Imprime uma imagem no relatório
@author Atilio
@since 06/06/2025
@version 1.0
/*/
  
Method SayBitmap(nLinha, nColuna, cImagem, nLargura, nAltura) Class zTMSPrinter
    If ::nColRecuo != 0
        nColuna  := nColuna - ::nColRecuo
    EndIf
    If ::nLinReTopo != 0
        nLinha  := nLinha - ::nLinReTopo
    EndIf
    ::oPrint:SayBitmap(nLinha, nColuna, cImagem, nLargura, nAltura)
Return
 
/*/{Protheus.doc} Box
Desenha um retângulo no relatório
@author Atilio
@since 06/06/2025
@version 1.0
/*/
  
Method Box(nLinha, nColuna, nAltura, nLargura) Class zTMSPrinter
    If ::nColRecuo != 0
        nColuna  := nColuna - ::nColRecuo
        nLargura := nLargura - ::nColRecuo
    EndIf
    If ::nLinReTopo != 0
        nLinha  := nLinha - ::nLinReTopo
        nAltura := nAltura - ::nLinReTopo
    EndIf
    ::oPrint:Box(nLinha, nColuna, nAltura, nLargura, /*cPixel*/)
Return
 
/*/{Protheus.doc} SetRecuo
Define um número de pixels para recuar
@author Atilio
@since 06/06/2025
@version 1.0
/*/
  
Method SetRecuo(nPixels) Class zTMSPrinter
    ::nColRecuo := nPixels
Return
 
/*/{Protheus.doc} SetRecuoTopo
Define um número de pixels para recuar ou avançar do topo da página
@author Atilio
@since 06/06/2025
@version 1.0
/*/
  
Method SetRecuoTopo(nPixels) Class zTMSPrinter
    ::nLinReTopo := nPixels
Return
