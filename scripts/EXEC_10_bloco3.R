# ==================================================
# BLOCO 3: ANALISE POPULACIONAL DETALHADA
# ==================================================

cat("\n=== BLOCO 3: ANALISE POPULACIONAL DETALHADA ===\n\n")

# Dados já carregados? Senão, carregar
if (!exists("df_populacional")) {
  df_original <- readRDS("dados_processados/clinvar_mlh1_com_gnomad.rds")
  df_populacional <- df_original
  
  # Recriar subgrupos (mesmo do Bloco 2)
  df_populacional$subgrupo <- cut(
    df_populacional$AF,
    breaks = c(0, 0.0001, 0.001, 0.01, 1),
    labels = c("Ultra_Rara", "Muito_Rara", "Rara", "Comum"),
    include.lowest = TRUE
  )
  
  cat("Dados recarregados e subgrupos recriados\n\n")
}

# ===== COMANDO 1: Tabela Gene x Subgrupo =====
cat("\n=== COMANDO 1: DISTRIBUICAO DE GENES POR SUBGRUPO ===\n")
cat("O que faz: Mostrar qual gene aparece em qual subgrupo\n")
cat("Por que: Genes diferentes podem ter padrões diferentes\n\n")

tabela_gene_subgrupo <- table(
  Gene = df_populacional$gene,
  Subgrupo = df_populacional$subgrupo
)

cat("Tabela Gene x Subgrupo (primeiros 10 genes):\n")
print(head(tabela_gene_subgrupo, 10))

cat("\nInterpretação:\n")
cat("- Cada linha = um gene\n")
cat("- Cada coluna = um subgrupo de frequência\n")
cat("- Números = quantidade de variantes\n\n")

# ===== COMANDO 2: Tabela Classificacao x Subgrupo =====
cat("\n=== COMANDO 2: DISTRIBUICAO DE CLASSIFICACOES POR SUBGRUPO ===\n")
cat("O que faz: Mostrar se Pathogenic tende a ser raro\n")
cat("Por que: Validar hipótese biologica\n\n")

# Criar coluna simplificada de classificação
df_populacional$class_simples <- ifelse(
  grepl("Pathogenic", df_populacional$classificacao_final),
  "Pathogenic",
  ifelse(
    grepl("VUS", df_populacional$classificacao_final),
    "VUS",
    "Benign"
  )
)

tabela_class_subgrupo <- table(
  Classificacao = df_populacional$class_simples,
  Subgrupo = df_populacional$subgrupo
)

print(tabela_class_subgrupo)

cat("\n\nProporção de cada classificação por subgrupo (%):\n")
proporcoes_class <- round(prop.table(tabela_class_subgrupo, margin = 2) * 100, 1)
print(proporcoes_class)

cat("\nInterpretação:\n")
cat("- Ultra_Rara tem muito Pathogenic? SIM\n")
cat("- Muito_Rara tem mais VUS? SIM\n")
cat("- Isto valida nossa classificação ACMG\n\n")

# ===== COMANDO 3: Estatísticas descritivas por subgrupo =====
cat("\n=== COMANDO 3: RESUMO ESTATISTICO POR SUBGRUPO ===\n")
cat("O que faz: Detalhes sobre cada subgrupo\n")
cat("Por que: Entender a fundo os padrões\n\n")

subgrupos_unicos <- levels(df_populacional$subgrupo)
subgrupos_unicos <- subgrupos_unicos[!is.na(subgrupos_unicos)]

for (subgrupo_atual in subgrupos_unicos) {
  subset_dados <- df_populacional[df_populacional$subgrupo == subgrupo_atual, ]
  
  n_variantes <- nrow(subset_dados)
  n_pathogenic <- sum(df_populacional$class_simples[df_populacional$subgrupo == subgrupo_atual] == "Pathogenic", na.rm = TRUE)
  n_vus <- sum(df_populacional$class_simples[df_populacional$subgrupo == subgrupo_atual] == "VUS", na.rm = TRUE)
  
  pct_pathogenic <- round(n_pathogenic / n_variantes * 100, 1)
  pct_vus <- round(n_vus / n_variantes * 100, 1)
  
  cat(sprintf("\n%s:\n", subgrupo_atual))
  cat(sprintf("  Total: %d variantes\n", n_variantes))
  cat(sprintf("  Pathogenic: %d (%.1f%%)\n", n_pathogenic, pct_pathogenic))
  cat(sprintf("  VUS: %d (%.1f%%)\n", n_vus, pct_vus))
  cat(sprintf("  Genes únicos: %d\n", length(unique(subset_dados$gene))))
} 

cat("\n\n=== FIM BLOCO 3 ===\n")