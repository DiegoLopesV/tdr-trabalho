figura_sazonalidade <- function(sazonalidade) {
  ggplot(
    sazonalidade,
    aes(mes, media_mwh_por_kwp, color = factor(ano), group = ano)
  ) +
    geom_line(linewidth = 0.9) +
    geom_point(size = 2) +
    scale_color_brewer(palette = "Dark2") +
    scale_y_continuous(labels = formatar_numero) +
    labs(x = "Mês", y = "Energia relativa (MWh/kWp)", color = "Ano") +
    theme_minimal(base_size = 12) +
    theme(legend.position = "bottom")
}

figura_categorias <- function(dados) {
  dados |>
    filter(!is.na(energia_mwh_por_kwp)) |>
    ggplot(aes(estrutura, energia_mwh_por_kwp, fill = estrutura)) +
    geom_boxplot(width = 0.5, outlier.alpha = 0.5) +
    scale_fill_brewer(palette = "Dark2", guide = "none") +
    scale_y_continuous(labels = formatar_numero) +
    labs(x = "Estrutura", y = "Energia relativa (MWh/kWp)") +
    theme_minimal(base_size = 12)
}

formatar_numero <- function(x) {
  format(x, decimal.mark = ",", big.mark = ".", trim = TRUE)
}
