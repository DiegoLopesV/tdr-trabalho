library(targets)
library(tarchetypes)

tar_option_set(packages = c("readr", "dplyr", "tidyr", "purrr", "ggplot2"))
tar_source("R")

list(
  tar_target(arquivo_cadastro, "dados/cadastro.csv", format = "file"),
  tar_target(arquivo_2023, "dados/geracao_2023.csv", format = "file"),
  tar_target(arquivo_2024, "dados/geracao_2024.csv", format = "file"),
  tar_target(arquivo_2025, "dados/geracao_2025.csv", format = "file"),
  tar_target(cadastro, ler_cadastro(arquivo_cadastro)),
  tar_target(
    geracao_anos,
    empilhar_anos(c(arquivo_2023, arquivo_2024, arquivo_2025))
  ),
  tar_target(dados, arrumar_geracao(geracao_anos, cadastro)),
  tar_target(conferencia, conferir_anos(dados)),
  tar_target(sem_medicao, identificar_sem_medicao(cadastro, dados)),
  tar_target(resumo_unidade, resumir_unidades(dados)),
  tar_target(resumo_categoria, resumir_categorias(dados)),
  tar_target(resumo_categoria_ano, resumir_categoria_ano(dados)),
  tar_target(resumo_ano, resumir_anos(dados)),
  tar_target(sazonalidade, resumir_sazonalidade(dados)),
  tar_target(resumo_mes, resumir_meses(dados)),
  tar_quarto(relatorio, "relatorio.qmd")
)
