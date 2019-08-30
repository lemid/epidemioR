# epidemioR � Estudos Aplicados de Epidemiologia usando R

Participantes
  * Camilla Castellar
  * Jhulia Gelain
  * Thiago Aguiar Carraro

Hor�rio e local
  * Sala 201
  * Departamento de Estat�stica
  * Sextas 14-17

Proximos passos
  * ensinar os turistas

## Orienta��es para os autores

### Estrutura de diret�rio e arquivos

TODO

### Figuras

A inclus�o de figuras � de duas formas: i) gr�ficos produzidos pelo
c�digo R e ii) imagens externas inclu�das por arquivo `*.png*`,
`*.jpg*`, etc.

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

### Tabelas

Assim como ocorre para as figuras, as tabelas colodas no texto poder sem
produzidas a partir do c�digo ou inclu�das diretamente no texto.

Para incluir tabelas geradas a partir de *data frames* no R pode-se usar
a fun��o `knitr::kable()`. A figura abaixo indica como us�-la com os
principais par�metros para controle de exibi��o da tabela.

![](./img/dataframe.png)

No caso da tabela ser inserida diretamente, tem-se que coloc�-la
usando-se sinxtaxe *markdown*. Felizmente, a tabela pode ser constru�da
em servi�os web ou gerada a partir de arquivos CSV, por
exemplo. Consulte os links abaixo.

  1. <https://tableconvert.com/>.
  2. <https://www.tablesgenerator.com/#>.
  3. <https://jakebathman.github.io/Markdown-Table-Generator/>.

Uma vez que a tabela for gerada em sintaxe markdown por um dos servi�os
acima (ou qualquer outro equivalente), ela pode ser inserida no texto
conforme ilustra a imagem a seguir.

![](./img/tabelamarkdown.png)

As mesmas formas de refer�ncia cruzada vistas para figuras est�o
dispon�veis para tabelas. A diferen�a � que o prefixo para tabela �
`tab:` e n�o `fig:`.

### Equa��es

Equa��es podem ser inseridas com sintaxe LaTeX. Os links abaixo apontam
para servi�os online que permitem a cria��o do c�digo das
equa��es. Depois de prontas � s� adicion�-las no texto.

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

### Refer�ncias bibliogr�ficas

As refer�ncias bibliogr�ficas s�o arquivadas em Bibtex. Para gerar o
c�digo de uma refer�ncia em Bibtex a partir do DOI ou do ISBN pode-se
usar um dos servi�os web, de 1 a 5, abaixo. Caso n�o seja poss�vel
us�-los, pode-se gerar a refer�ncia com o servi�o 6, preenchendo os
campos conforme o tipo de refer�ncia.

  1. <https://www.doi2bib.org/>.
  2. <http://doi-to-bibtex-converter.herokuapp.com/>.
  3. <https://manas.tungare.name/software/isbn-to-bibtex>.
  4. <https://www.ottobib.com/>.
  5. <http://www.bibme.org/bibtex/journal-citation>.
  6. <https://truben.no/latex/bibtex/>.

O fragmento de c�digo gerado deve ser colocado em um arquivo `*.bib` que
deve ter o caminho informado no campo `bibliography` do cabe�alho do
arquivo `index.Rmd`.

```
bibliography: [<caminho-arquivo-1.bib>, <caminho-arquivo-2.bib>]
```

A figura a seguir indica a sintaxe usada para fazer as refer�ncias
diretas e entre par�nteses ao final de par�grafos.

![](./img/referencias.png)
