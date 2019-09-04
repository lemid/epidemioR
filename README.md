# epidemioR � Epidemiologia de Doen�as de Plantas Aplicada com R

O objetivo do `epidemioR` � fazer a documenta��o do uso do software R no
desenvolvimento, aplica��o e avalia��o m�todos para an�lise de dados em
epidemiologia para manejo de doen�as em plantas com temas espec�ficos de
interesse dos professores, pesquisadores e alunos.

Este material � produzido devido � colabora��o de professores e alunos
do Programa de P�s Gradua��o em Produ��o Vegetal, com colabora��o de
professores e pesquisadores externos.

## Orienta��es para os autores

As orienta��es a seguir s�o para contribuir com a editora��o do
material. Elas cont�m orienta��es de organiza��o e sintaxe para
contru��o de elementos textuais.

### Sintaxe Rmarkdown

A sintaxe markdown � amplamente documentada na web. O Rmarkdown permite
a inclus�o de fragmentos de c�digo R. Tamb�m � bem documentado na
web. Por essa raz�o, aqui ser�o apontados materiais de consulta
recomendados.

  1. <https://www.rstudio.com/wp-content/uploads/2016/03/rmarkdown-cheatsheet-2.0.pdf>.
  2. <https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf>.
  3. <https://guides.github.com/pdfs/markdown-cheatsheet-online.pdf>.
  4. <https://en.support.wordpress.com/markdown-quick-reference/>.
  5. <https://bookdown.org/yihui/rmarkdown/>.
  6. <https://cran.r-project.org/web/packages/stationery/vignettes/Rmarkdown.pdf>.

### Estrutura de diret�rio e arquivos

Para organizar a elabora��o do material de forma a garantir autonomia
para os autores e menos problemas com conflitos de edi��o de arquivos,
ser� adotada a seguinte estrutura de diret�rio.

```
epidemioR/
  |-- _output.yml                Arquivo de configura��es.
  |-- _bookdown.yml              Arquivo de internacionaliza��o.
  |-- index.Rmd                  Capa e configura��es principais.
  |-- config/                    Diret�rio com arquivos de conf.
  |-- img/                       Para imagens de capa, etc.
  |
  |-- <nome-do-capitulo-1>.Rmd   Cap�tulo do livro.
  |-- <nome-do-capitulo-1>/      Diret�rio com arquivos do cap�tulo.
  |    |-- *.png, *.jpg, etc.    Arquivos de imagem.
  |    |-- *.txt, *.csv, etc.    Arquivos com dados em texto pleno.
  |    `-- refs.bib              Arquivo com refer�ncias bibliogr�ficas.
  |
  |-- <nome-do-capitulo-2>.Rmd   Outro cap�tulo do livro.
  `-- <nome-do-capitulo-2>/      Outro diret�rio com arquivos.
       |-- *.png, *.jpg, etc.
       |-- *.txt, *.csv, etc.    E segue assim.
       `-- refs.bib
```

Cada cap�tulo ser� composto de um arquivo Rmarkdown (`*.Rmd`) e um
diret�rio onde ficar�o os arquivos para o cap�tulo. O mesmo nome deve
ser usado para o arquivo e diret�rio. Por exemplo, o nome pode ser
`regressao-linear-para-cpd-em-macieira` ou
`analise-da-resistencia-a-fungicidas`. Quanto mais descritivo o nome,
melhor. Por�m, usar o bom senso para o nome n�o ficar t�o grande.

No diret�rio do cap�tulo devem ficar as imagens que ser�o usadas, por
exemplo, para indicar o delineamento experimental ou o estado das les�es
nos frutos. Arquivos `*.csv` ou `*.txt` contendo os dados crus devem
estar no diret�rio tamb�m.

O diret�rio deve conter um arquivo chamado `refs.bib` com as refer�ncias
bibligr�ficas em sintaxe bibtex. S�o dados mais detalhes sobre isso na
se��o sobre refer�ncias bibligr�ficas.

No come�o de cada cap�tulo deve se indicar os autores com o seguinte
fragmento entre o t�tulo e o primeiro par�grafo no arquivo Rmarkdown.

    ```{r, echo = FALSE, results = "asis"}
    chapter_authors(c("Walmes Marques Zeviani", "Larissa May de Mio"))
    ```

### Inclus�o de figuras

A inclus�o de figuras � de duas formas: i) gr�ficos produzidos pelo
c�digo R e ii) imagens externas inclu�das por arquivo `*.png`,
`*.jpg`, etc.

Para gr�ficos do R, basta criar um fragmento de c�digo que crie o
gr�fico que ele ser� inclu�do no documento final. Recomenda-se a
inclus�o de uma legenda para o gr�fico que � indica no par�metro
`fig.cap` do cabe�alho de fragmento de c�digo.

A figura a seguir indica como incluir um gr�fico gerado pelo R.

![](./img/grafico.png)

A figura a seguir indica como incluir uma imagem em arquivo externo.

![](./img/imagem.png)

Aten��o para duas coisas:

  1. A demarca��o `(ref:<texto-unico-identicador>)` serve para passar a
     legenda para o par�metro `fig.cap` do cabe�alho de fragmento de
     c�digo. A legenda pode ser longa, conter representa��o especial
     como equa��es, ent�o dessa maneira acomoda-se essas
     caracter�sticas.
  2. A demarca��o `\@ref(<texto-unico-de-referencia>)` serve para
     identificar a figura de modo a permitir refer�ncias cruzadas no
     texto. A sugest�o � que se use o nome do arquivo (sem a extens�o)
     como nome de refer�ncia.

### Inclus�o de tabelas

Assim como ocorre para as figuras, as tabelas colocas no texto poder sem
produzidas i) a partir do c�digo ou ii) inclu�das diretamente no texto.

Para incluir tabelas geradas a partir de *data frames* no R pode-se usar
a fun��o `knitr::kable()`. Existem outros pacotes que tamb�m exportam
tabelas para a sintaxe *markdown*, mas este � simples de usar e atende as
necessidades. A figura abaixo indica como us�-la com os principais
par�metros para controle de exibi��o da tabela.

![](./img/dataframe.png)

No caso da tabela ser inserida diretamente, tem-se que coloc�-la
usando-se sintaxe *markdown*. Felizmente, a tabela pode ser constru�da
em servi�os web ou gerada a partir de arquivos CSV, por
exemplo. Consulte os links abaixo.

  1. <https://tableconvert.com/>.
  2. <https://www.tablesgenerator.com/#>.
  3. <https://www.latex-tables.com/>.
  4. <https://jakebathman.github.io/Markdown-Table-Generator/>.

Uma vez que a tabela for gerada em sintaxe *markdown* por um dos
servi�os acima (ou qualquer outro equivalente), ela pode ser inserida no
texto conforme ilustra a imagem a seguir.

![](./img/tabelamarkdown.png)

As mesmas formas de refer�ncia cruzada vistas para figuras est�o
dispon�veis para tabelas. A diferen�a � que o prefixo para tabela �
`tab:` e n�o `fig:`.

Tabelas que sejam mais complexas, por exemplo, com c�dulas mescladas,
quebra de texto dentro das c�dulas, podem ser feitas em outros softwares
e inclu�das como imagem. O pacote
[kableExtra](https://haozhu233.github.io/kableExtra/save_kable_and_as_image.html)
tem recursos adicionais para constru��o de tabelas e convers�o para
imagens.

### Inclus�o de equa��es e anota��es matem�ticas

Equa��es podem ser inseridas com sintaxe LaTeX. Os links abaixo apontam
para servi�os online que permitem a cria��o das equa��es em
LaTeX. Depois de prontas � s� adicion�-las no texto.

  1. <https://www.codecogs.com/latex/eqneditor.php>.
  2. <https://hostmath.com/>.
  3. <https://www.latex4technics.com/>.

A imagem a seguir indica como adicionar equa��es que ficam centralizadas
na p�gina (em bloco, usar `$$`) e que ficam no par�grafo (em linha, usar
`$`).

![](./img/equacao.png)

No caso de uma equa��o ter que ser referenciada no texto, deve-se usar
os mecan�smos de refer�ncia cruzada. A figura a seguir indica como fazer
isso. O processo � an�logo ao visto para figuras e tabelas. A diferen�a
� que o prefixo para equa��es � `eq:`.

![](./img/equacaoreferencia.png)

### Cita��o de refer�ncias bibliogr�ficas

As refer�ncias bibliogr�ficas s�o arquivadas em formato BibTeX. Para
gerar o c�digo de uma refer�ncia em BibTeX a partir do DOI do artigo, do
ISBN do livro, do t�tulo da refer�ncia, da refer�ncia formatada, da
entrada BibTeX parcial, etc, pode-se usar um dos servi�os web, softwares
ou pacotes abaixo.

  1. DOI para BibTeX: <https://www.doi2bib.org/>.
  2. DOI/ISBN/URL para Bibtex:
     <http://doi-to-bibtex-converter.herokuapp.com/> e
     <http://doi-to-bibtex.herokuapp.com/>.
  4. ISBN para BibTeX:
     <https://manas.tungare.name/software/isbn-to-bibtex>.
  5. ISBN para BibTeX: <https://www.ottobib.com/>.
  6. ISBN para BibTex: <https://www.xarg.org/tools/isbn-to-bibtex/>.
  7. T�tulo para BibTeX: <http://www.bibme.org/bibtex/journal-citation>.
  8. Estrutura para BibTeX a partir da refer�ncia formatada:
     <https://anystyle.io/>.
  9. Servi�o para preencher campos manualmente e criar BibTeX:
     <https://truben.no/latex/bibtex/>.
  10. DOI para BibTeX com Python (`urllib`):
      <https://scipython.com/blog/doi-to-bibtex/>.
  11. Completa/henriquece refer�ncias BibTeX:
      <https://github.com/nschloe/betterbib>.
  12. DOI para BibTeX com `curl` e Emacs:
      <https://tex.stackexchange.com/questions/6848/automatically-dereference-doi-to-bib>.
  13. Pacotes R:
      1. [`RefManageR`](https://cran.r-project.org/package=RefManageR):
         permite importar, manipular e fazer refer�ncias em documentos
         Rmarkdown. Tem interface para
         [CrossRef](https://www.crossref.org/) e
         [Zotero](https://www.zotero.org/). Consegue importar refer�ncia
         de PDF usando `poppler`.
      2. [`doi2bib`](https://rdrr.io/github/wkmor1/doi2bib/): usa o
         <https://www.doi2bib.org/> para importar o BibTeX.
      3. [`bib2df`](https://cran.r-project.org/web/packages/bib2df/vignettes/bib2df.html):
         Cria tabelas a partir de arquivo `*.bib`. � �til para gerar
         tabelas resumo de refer�ncias e visualiza��es.
  14. O software [JabRef](http://www.jabref.org/) possui recurso de
      importa��o por DOI, ISBN e outros identificadores �nicos.

O [Mendeley](https://www.mendeley.com/) tamb�m exporta refer�ncias para
BibTeX. Selecionando v�rias refer�ncias, pode-se, com o bot�o direito do
mouse, clicar em `Export...` para criar um arquivo `*.bib` com a
cole��o. Ao escolher `Copy as > BibTeX Entry`, o conte�do em formato
BibTeX � copiado para a �rea de transfer�ncia, ent�o � s� colar dentro
de um arquivo j� existente.

![](./img/mendeley.png)

Os fragmentos de c�digo de cada refer�ncia em BibTeX gerados devem ser
colocados em um arquivo `refs.bib` que deve ter o caminho informado no
campo `bibliography` do cabe�alho do arquivo `index.Rmd`.

```
bibliography: [<nome-do-capitulo-1>/refs.bib, <nome-do-capitulo-2>/refs.bib]
```

A figura a seguir indica a sintaxe usada para fazer as refer�ncias
diretas e entre par�nteses ao final de par�grafos. A sintaxe � preceder
o nome da refer�ncia com o `@`.

![](./img/referencias.png)
