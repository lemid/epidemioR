# epidemioR · Estudos Aplicados de Epidemiologia usando R

Participantes
  * Camilla Castellar
  * Jhulia Gelain
  * Thiago Aguiar Carraro

Horário e local
  * Sala 201
  * Departamento de Estatística
  * Sextas 14-17

Proximos passos
  * ensinar os turistas

## Orientações para os autores

### Estrutura de diretório e arquivos

TODO

### Figuras

A inclusão de figuras é de duas formas: i) gráficos produzidos pelo
código R e ii) imagens externas incluídas por arquivo `*.png*`,
`*.jpg*`, etc.

Para gráficos do R, basta criar um fragmento de código que crie o
gráfico que ele será incluído no documento final. Recomenda-se a
inclusão de uma legenda para o gráfico que é indica no parâmetro
`fig.cap` do cabeçalho de fragmento de código.

A figura a seguir indica como incluir um gráfico gerado pelo R.

![](./img/grafico.png)

A figura a seguir indica como incluir uma imagem em arquivo externo.

![](./img/imagem.png)

Atenção para duas coisas:

  1. A demarcação `(ref:<texto-unico-identicador>)` serve para passar a
     legenda para o parâmetro `fig.cap` do cabeçalho de fragmento de
     código. A legenda pode ser longa, conter representação especial
     como equações, então dessa maneira acomoda-se essas
     características.
  2. A demarcação `\@ref(<texto-unico-de-referencia>)` serve para
     identificar a figura de modo a permitir referências cruzadas no
     texto. A sugestão é que se use o nome do arquivo (sem a extensão)
     como nome de referência.

### Tabelas

Assim como ocorre para as figuras, as tabelas colodas no texto poder sem
produzidas a partir do código ou incluídas diretamente no texto.

Para incluir tabelas geradas a partir de *data frames* no R pode-se usar
a função `knitr::kable()`. A figura abaixo indica como usá-la com os
principais parâmetros para controle de exibição da tabela.

![](./img/dataframe.png)

No caso da tabela ser inserida diretamente, tem-se que colocá-la
usando-se sinxtaxe *markdown*. Felizmente, a tabela pode ser construída
em serviços web ou gerada a partir de arquivos CSV, por
exemplo. Consulte os links abaixo.

  1. <https://tableconvert.com/>.
  2. <https://www.tablesgenerator.com/#>.
  3. <https://jakebathman.github.io/Markdown-Table-Generator/>.

Uma vez que a tabela for gerada em sintaxe markdown por um dos serviços
acima (ou qualquer outro equivalente), ela pode ser inserida no texto
conforme ilustra a imagem a seguir.

![](./img/tabelamarkdown.png)

As mesmas formas de referência cruzada vistas para figuras estão
disponíveis para tabelas. A diferença é que o prefixo para tabela é
`tab:` e não `fig:`.

### Equações

Equações podem ser inseridas com sintaxe LaTeX. Os links abaixo apontam
para serviços online que permitem a criação do código das
equações. Depois de prontas é só adicioná-las no texto.

  1. <https://www.codecogs.com/latex/eqneditor.php>.
  2. <https://hostmath.com/>.
  3. <https://www.latex4technics.com/>.

A imagem a seguir indica como adicionar equações que ficam centralizadas
na página (em bloco, usar `$$`) e que ficam no parágrafo (em linha, usar
`$`).

![](./img/equacao.png)

No caso de uma equação ter que ser referenciada no texto, deve-se usar
os mecanísmos de referência cruzada. A figura a seguir indica como fazer
isso. O processo é análogo ao visto para figuras e tabelas. A diferença
é que o prefixo para equações é `eq:`.

![](./img/equacaoreferencia.png)

### Referências bibliográficas

As referências bibliográficas são arquivadas em Bibtex. Para gerar o
código de uma referência em Bibtex a partir do DOI ou do ISBN pode-se
usar um dos serviços web, de 1 a 5, abaixo. Caso não seja possível
usá-los, pode-se gerar a referência com o serviço 6, preenchendo os
campos conforme o tipo de referência.

  1. <https://www.doi2bib.org/>.
  2. <http://doi-to-bibtex-converter.herokuapp.com/>.
  3. <https://manas.tungare.name/software/isbn-to-bibtex>.
  4. <https://www.ottobib.com/>.
  5. <http://www.bibme.org/bibtex/journal-citation>.
  6. <https://truben.no/latex/bibtex/>.

O fragmento de código gerado deve ser colocado em um arquivo `*.bib` que
deve ter o caminho informado no campo `bibliography` do cabeçalho do
arquivo `index.Rmd`.

```
bibliography: [<caminho-arquivo-1.bib>, <caminho-arquivo-2.bib>]
```

A figura a seguir indica a sintaxe usada para fazer as referências
diretas e entre parênteses ao final de parágrafos.

![](./img/referencias.png)
