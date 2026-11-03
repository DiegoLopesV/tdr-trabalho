# Meses sem registro permanecem NA; médias e totais usam só os registros válidos.
resumir_unidades <- function(dados) {
  dados |>
    group_by(ano, codigo, nome, estrutura) |>
    summarise(
      meses_com_registro = sum(!is.na(energia_mwh)),
      total_ano_mwh = sum(energia_mwh, na.rm = TRUE),
      media_mwh_por_kwp = mean(energia_mwh_por_kwp, na.rm = TRUE),
      .groups = "drop"
    ) |>
    arrange(ano, desc(media_mwh_por_kwp))
}

resumir_categorias <- function(dados) {
  dados |>
    group_by(estrutura) |>
    summarise(
      unidades = n_distinct(codigo),
      meses_com_registro = sum(!is.na(energia_mwh)),
      total_mwh = sum(energia_mwh, na.rm = TRUE),
      media_mwh_por_kwp = mean(energia_mwh_por_kwp, na.rm = TRUE),
      .groups = "drop"
    )
}

resumir_categoria_ano <- function(dados) {
  dados |>
    group_by(estrutura, ano) |>
    summarise(total_mwh = sum(energia_mwh, na.rm = TRUE), .groups = "drop") |>
    pivot_wider(names_from = ano, values_from = total_mwh)
}

resumir_anos <- function(dados) {
  dados |>
    group_by(ano) |>
    summarise(
      registros = sum(!is.na(energia_mwh)),
      total_mwh = sum(energia_mwh, na.rm = TRUE),
      media_mwh_por_kwp = mean(energia_mwh_por_kwp, na.rm = TRUE),
      .groups = "drop"
    )
}

resumir_sazonalidade <- function(dados) {
  dados |>
    group_by(ano, mes) |>
    summarise(
      media_mwh_por_kwp = mean(energia_mwh_por_kwp, na.rm = TRUE),
      .groups = "drop"
    )
}

resumir_meses <- function(dados) {
  dados |>
    group_by(mes) |>
    summarise(
      media_mwh_por_kwp = mean(energia_mwh_por_kwp, na.rm = TRUE),
      .groups = "drop"
    )
}
