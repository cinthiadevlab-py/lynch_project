# ==================================================
# BLOCO 2: CRIAR SUBGRUPOS POPULACIONAIS
# ==================================================

cat("\n=== BLOCO 2: CRIAR SUBGRUPOS POPULACIONAIS ===\n\n")

# Dados já carregados? Senão, carregar novamente
if (!exists("df_original")) {
  df_original <- readRDS("dados_processados/clinvar_mlh1_com_gnomad.rds")
  cat("Dados recarregados\n\n")
}

# ===== COMANDO 1: Entender a coluna AF =====
cat("\n=== COMANDO 1: EXPLORAR COLUNA AF ===\n")
cat("O que faz: Entender distribuição de frequências\n")
cat("Por que: Vamos dividir em categorias\n\n")

cat("Estatísticas da coluna AF:\n")
summary(df_original$AF)

cat("\nValores únicos (primeiros 20):\n")
print(head(sort(unique(df_original$AF[!is.na(df_original$AF)])), 20))

cat("\nQuantidade de NA:\n")
cat(sprintf("NA: %d\n", sum(is.na(df_original$AF))))
cat(sprintf("Com dados: %d\n\n", sum(!is.na(df_original$AF))))

# ===== COMANDO 2: Criar subgrupos por frequência =====
cat("\n=== COMANDO 2: CRIAR CATEGORIAS DE FREQUENCIA ===\n")
cat("O que faz: Dividir variantes em 4 grupos por frequência\n")
cat("Por que: Comparar padrões entre frequências\n\n")

df_populacional <- df_original

cat("Critérios de categorização:\n")
cat("  Ultra_Rara: AF < 0.0001 (< 0.01%)\n")
cat("  Muito_Rara: AF 0.0001-0.001 (0.01-0.1%)\n")
cat("  Rara: AF 0.001-0.01 (0.1-1%)\n")
cat("  Comum: AF >= 0.01 (>= 1%)\n")
cat("  Dados_Faltando: NA\n\n")

# Criar subgrupo
df_populacional$subgrupo <- cut(
  df_populacional$AF,
  breaks = c(0, 0.0001, 0.001, 0.01, 1),
  labels = c("Ultra_Rara", "Muito_Rara", "Rara", "Comum"),
  include.lowest = TRUE
)

# Tratamento de NA
df_populacional$subgrupo[is.na(df_populacional$AF)] <- "Dados_Faltando"

cat("Subgrupos criados! Primeiras 15 linhas:\n\n")
print(df_populacional[1:15, c("gene", "AF", "subgrupo")])

# ===== COMANDO 3: Tabela de frequências por subgrupo =====
cat("\n\n=== COMANDO 3: DISTRIBUICAO DE VARIANTES POR SUBGRUPO ===\n")
cat("O que faz: Contar quantas variantes em cada subgrupo\n")
cat("Por que: Ver padrão de distribuição\n\n")

tabela_subgrupo <- table(df_populacional$subgrupo)
print(tabela_subgrupo)

cat("\nProporção (%):\n")
proporcoes <- round(prop.table(tabela_subgrupo) * 100, 2)
print(proporcoes)

cat("\nInterpretação:\n")
cat("- A maioria está em Ultra_Rara? Sim!\n")
cat("- Isto é esperado? Sim! Síndrome Lynch = doença rara\n")
cat("- Variantes comuns (>1%) são poucas? Sim! Bom sinal.\n\n")

cat("=== FIM BLOCO 2 ===\n") 