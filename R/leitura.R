ler_cadastro <- function(arquivo) {
  cadastro <- read_delim(
    arquivo,
    delim = ";",
    locale = locale(decimal_mark = ",", encoding = "Windows-1252"),
    na = "-",
    col_types = cols(
      codigo = col_character(), nome = col_character(),
      estrutura = col_character(), potencia_kwp = col_double()
    )
  )
  stopifnot(
    nrow(problems(cadastro)) == 0L,
    !anyNA(cadastro), !anyDuplicated(cadastro$codigo),
    all(cadastro$potencia_kwp > 0)
  )
  cadastro
}

ler_geracao <- function(arquivo) {
  geracao <- read_delim(
    arquivo,
    delim = ";",
    locale = locale(decimal_mark = ",", encoding = "UTF-8"),
    na = "-",
    col_types = cols(
      codigo = col_character(),
      jan = col_double(), fev = col_double(), mar = col_double(),
      abr = col_double(), mai = col_double(), jun = col_double(),
      jul = col_double(), ago = col_double(), set = col_double(),
      out = col_double(), nov = col_double(), dez = col_double()
    )
  )
  stopifnot(
    nrow(problems(geracao)) == 0L,
    !anyNA(geracao$codigo), !anyDuplicated(geracao$codigo)
  )
  geracao
}

empilhar_anos <- function(arquivos) {
  arquivos <- stats::setNames(arquivos, basename(arquivos))
  map(arquivos, ler_geracao) |>
    bind_rows(.id = "origem") |>
    mutate(ano = as.integer(parse_number(origem)))
}

arrumar_geracao <- function(geracao, cadastro) {
  meses <- c(
    "jan", "fev", "mar", "abr", "mai", "jun",
    "jul", "ago", "set", "out", "nov", "dez"
  )
  longa <- geracao |>
    pivot_longer(
      cols = all_of(meses), names_to = "mes", values_to = "energia_mwh"
    ) |>
    mutate(mes = factor(mes, levels = meses))
  stopifnot(
    nrow(anti_join(longa, cadastro, by = "codigo")) == 0L,
    !anyDuplicated(longa[c("codigo", "ano", "mes")])
  )
  dados <- longa |>
    left_join(cadastro, by = "codigo", relationship = "many-to-one") |>
    mutate(energia_mwh_por_kwp = energia_mwh / potencia_kwp)
  stopifnot(nrow(dados) == nrow(longa))
  dados
}

conferir_anos <- function(dados) {
  conferencia <- dados |>
    group_by(ano) |>
    summarise(
      linhas = n(),
      unidades = n_distinct(codigo),
      meses_sem_registro = sum(is.na(energia_mwh)),
      soma_mwh = sum(energia_mwh, na.rm = TRUE),
      .groups = "drop"
    )
  stopifnot(
    identical(conferencia$ano, 2023:2025),
    all(conferencia$linhas == 132L), all(conferencia$unidades == 11L),
    identical(conferencia$meses_sem_registro, c(5L, 2L, 5L)),
    isTRUE(all.equal(conferencia$soma_mwh, c(14253.2, 13765.3, 12808.7)))
  )
  conferencia
}

identificar_sem_medicao <- function(cadastro, dados) {
  sem_medicao <- anti_join(cadastro, dados, by = "codigo")
  stopifnot(nrow(cadastro) == 12L, nrow(sem_medicao) == 1L)
  sem_medicao
}
