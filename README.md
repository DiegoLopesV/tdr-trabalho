# tdr-trabalho

Trabalho intermediário de Tecnologia de Dados, de Diego Lopes Vieira.
O projeto transforma a análise da Lista 03 em um pipeline reprodutível de
geração de energia solar, usando dados simulados para o login `diegolopesv`.

## Como reproduzir

Instale previamente o Git, o R 4.6.1 e o Quarto CLI 1.9.38, disponível no
`PATH` (confira com `quarto --version`). O pacote R `quarto` não substitui o
Quarto CLI. É necessária conexão à internet na primeira restauração.
O RStudio é opcional.

Depois de clonar o repositório, selecionar o ramo `trabalho` e abrir o R
na raiz do projeto, execute estes dois comandos:

```r
renv::restore()
targets::tar_make()
```

O primeiro restaura as versões de `renv.lock`; o segundo lê os dados,
confere os valores, calcula os resumos e gera `relatorio.html`, com as
figuras incorporadas. Abra esse arquivo em um navegador.
O arquivo `tdr-trabalho.Rproj` abre a raiz correta no RStudio.

Em Ubuntu 24.04, instale também as bibliotecas de sistema listadas no passo
correspondente de `.github/workflows/relatorio.yaml`, antes de restaurar.
O workflow instala o R e o Quarto, restaura os pacotes e executa o pipeline
em envios a `main` e `trabalho` e em pull requests. O HTML fica no artefato
`relatorio`, na página da execução em Actions.

## Dados e análise

Os cinco arquivos de `dados/` são preservados byte a byte em relação ao zip
publicado para o login. O cadastro usa Windows-1252; as medições usam UTF-8.
O separador é ponto e vírgula, o decimal é vírgula e `-` representa ausência.
Os meses sem registro permanecem `NA`, não são substituídos por zero e são
excluídos das médias. Os totais somam apenas valores registrados.

O pipeline verifica os tipos de leitura, códigos únicos, correspondência
completa ao cadastro e cardinalidade da junção. A conferência anual verifica
linhas, usinas, ausentes e somas contra o `LEIA-ME.txt`.
O relatório responde sobre sazonalidade, variação da média relativa entre os
anos e diferenças entre estruturas. O modelo opcional não foi incluído.

## Arquivos

| Arquivo | Conteúdo |
| --- | --- |
| `dados/` | Cadastro, medições anuais e descrição originais. |
| `analise.qmd` | Documento da Lista 03 preservado como ponto de partida. |
| `_targets.R` | Alvos de arquivos, leitura, transformação, resumos e relatório. |
| `R/leitura.R` | Leitura declarada, empilhamento, junção e conferências. |
| `R/resumos.R` | Resumos por usina, categoria, ano e mês. |
| `R/figuras.R` | Figuras de sazonalidade e distribuição por categoria. |
| `relatorio.qmd` | Apresentação dos alvos, com números em código em linha. |
| `_dependencies.R` | Dependências usadas indiretamente pelo pipeline. |
| `renv.lock` | Versões do R e dos pacotes. |
| `.Rprofile` e `renv/` | Ativação e configurações da biblioteca isolada. |
| `.github/workflows/relatorio.yaml` | Execução do pipeline no GitHub Actions. |
| `.lintr` | Estilo de dois espaços e exceções do projeto. |
| `.gitattributes` | Preservação dos bytes de `dados/` nas diferentes plataformas. |
| `.gitignore` | Exclusão de resultados gerados e arquivos de sessão. |
| `tdr-trabalho.Rproj` | Projeto do RStudio. |
| `LICENSE` | Licença GPL-3.0. |

## Verificação e desenvolvimento

O ponto de partida fica no `main`. As etapas seguintes ficam no ramo
`trabalho`, com commits no padrão `Etapa N`.
O pull request deve permanecer aberto até a revisão do professor.

Para verificar o estilo na biblioteca isolada, instale a ferramenta com
`renv::install("lintr")` e execute `lintr::lint_dir()` na raiz.
O `lintr` é uma ferramenta de desenvolvimento e não entra no registro de
dependências da análise. A regra `object_usage_linter` está desligada porque
as funções usam os pacotes declarados em `tar_option_set()` e as colunas
referenciadas pela avaliação de dados do dplyr e do ggplot2.
O documento histórico `analise.qmd` e o código gerado do `renv/` ficam
excluídos da análise de estilo; o relatório novo e as funções são verificados.

## Uso de LLMs

Foi utilizado o Codex (CLI de IA), da OpenAI, para suporte na adaptação da análise da Lista 03 para funções e alvos, na redação do relatório e nas verificações.
