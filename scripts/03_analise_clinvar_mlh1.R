# ==================================================
# PROJETO LYNCH - SÍNDROME DE LYNCH
# Script 03 - Análise Exploratória Descritiva (EDA)
# ==================================================
#
# OBJETIVO:
# Caracterizar completamente o dataset MLH1 em termos:
# - Clínicos (condições, classificações)
# - Moleculares (consequências, tipos de variantes)
# - Epidemiológicos (frequências, distribuições)
#
# OUTPUT:
# - 4 gráficos PNG (figuras/)
# - 4 arquivos CSV (resultados/)
# - Relatório no console
# ==================================================

# ==================================================
# 1. CARREGAMENTO E VALIDAÇÃO INICIAL
# ==================================================

cat("\n=== INICIANDO SCRIPT 03 ===\n")
cat("Carregando dados processados...\n")

# Validar arquivo
if (!file.exists("dados_processados/clinvar_mlh1_limpo.rds")) {
  stop("❌ ERRO: RDS não encontrado!\nExecute Script 02 primeiro.")
}

# Carregar dados
clinvar <- readRDS("dados_processados/clinvar_mlh1_limpo.rds")

cat("✅ Dados carregados com sucesso!\n")
cat(sprintf("   Dimensões: %d linhas × %d colunas\n", 
            nrow(clinvar), ncol(clinvar)))
cat(sprintf("   Colunas: %s\n", paste(names(clinvar), collapse = ", ")))

# ==================================================
# 2. ANÁLISE CLÍNICA - CLASSIFICAÇÕES
# ==================================================

cat("\n=== ANÁLISE CLÍNICA - CLASSIFICAÇÕES ===\n")

# Distribuição de classificações
classificacao <- sort(
  table(clinvar$Germline.classification),
  decreasing = TRUE
)

cat("\nDistribuição de classificações germline:\n")
print(classificacao)

cat("\nProporção (%):\n")
classificacao_pct <- round(prop.table(classificacao) * 100, 2)
print(classificacao_pct)

# Exportar resultado
df_classificacao <- data.frame(
  Classificacao = names(classificacao),
  Frequencia = as.numeric(classificacao),
  Percentual = as.numeric(classificacao_pct),
  row.names = NULL,
  stringsAsFactors = FALSE
)

write.csv(df_classificacao, 
          "results/classificacao_germline.csv", 
          row.names = FALSE)
cat("✅ Resultados salvos em: results/classificacao_germline.csv\n")

# Gráfico 1: Classificações
png("figures/01_classificacao_germline.png", 
    width = 800, height = 600, res = 100)

coord_x <- barplot(
  classificacao,
  main = "Classificação Clínica das Variantes MLH1",
  ylab = "Número de registros",
  col = c("darkred", "orange"),
  ylim = c(0, max(classificacao) * 1.15)
)

text(x = coord_x, y = classificacao, 
     labels = classificacao, pos = 3, font = 2)

dev.off()
cat("✅ Gráfico salvo em: figures/01_classificacao_germline.png\n")

# ==================================================
# 3. ANÁLISE CLÍNICA - STATUS DE REVISÃO
# ==================================================

cat("\n=== ANÁLISE CLÍNICA - STATUS DE REVISÃO ===\n")

review_status <- sort(
  table(clinvar$Germline.review.status),
  decreasing = TRUE
)

cat("\nDistribuição de status de revisão:\n")
print(review_status)

cat("\nProporção (%):\n")
review_pct <- round(prop.table(review_status) * 100, 2)
print(review_pct)

# Exportar resultado
df_review <- data.frame(
  Status = names(review_status),
  Frequencia = as.numeric(review_status),
  Percentual = as.numeric(review_pct),
  row.names = NULL,
  stringsAsFactors = FALSE
)

write.csv(df_review, 
          "results/review_status.csv", 
          row.names = FALSE)
cat("✅ Resultados salvos em: results/review_status.csv\n")

# Gráfico 2: Status de revisão
png("figures/02_review_status.png", 
    width = 1000, height = 600, res = 100)

coord_x <- barplot(
  review_status,
  main = "Nível de Evidência Clínica das Variantes MLH1",
  ylab = "Número de registros",
  las = 2,
  cex.names = 0.8,
  col = "steelblue",
  ylim = c(0, max(review_status) * 1.15)
)

text(x = coord_x, y = review_status, 
     labels = review_status, pos = 3, font = 2)

dev.off()
cat("✅ Gráfico salvo em: figures/02_review_status.png\n")

# ==================================================
# 4. ANÁLISE CLÍNICA - CONDIÇÕES
# ==================================================

cat("\n=== ANÁLISE CLÍNICA - CONDIÇÕES ASSOCIADAS ===\n")

condicoes <- sort(
  table(clinvar$Condition.s.),
  decreasing = TRUE
)

cat(sprintf("Total de condições clínicas únicas: %d\n", 
            length(unique(clinvar$Condition.s.))))

cat("\nTop 20 condições clínicas:\n")
top20_condicoes <- head(condicoes, 20)
print(top20_condicoes)

# Exportar resultado
df_condicoes <- data.frame(
  Condicao = names(top20_condicoes),
  Frequencia = as.numeric(top20_condicoes),
  Percentual = round(as.numeric(top20_condicoes) / sum(condicoes) * 100, 2),
  row.names = NULL,
  stringsAsFactors = FALSE
)

write.csv(df_condicoes, 
          "results/top_condicoes.csv", 
          row.names = FALSE)
cat("✅ Resultados salvos em: results/top_condicoes.csv\n")

# Gráfico 3: Top 10 condições
png("figures/03_top_condicoes.png", 
    width = 1200, height = 700, res = 100)

top10_condicoes <- head(condicoes, 10)

coord_x <- barplot(
  top10_condicoes,
  main = "Top 10 Condições Clínicas Associadas ao MLH1",
  ylab = "Número de registros",
  las = 2,
  cex.names = 0.7,
  col = "darkgreen",
  ylim = c(0, max(top10_condicoes) * 1.15)
)

text(x = coord_x, y = top10_condicoes, 
     labels = top10_condicoes, pos = 3, font = 2)

dev.off()
cat("✅ Gráfico salvo em: figures/03_top_condicoes.png\n")

# ==================================================
# 5. ANÁLISE MOLECULAR - CONSEQUÊNCIAS
# ==================================================

cat("\n=== ANÁLISE MOLECULAR - CONSEQUÊNCIAS ===\n")

# Consequências simples (sem splitting)
consequencias_simples <- sort(
  table(clinvar$Molecular.consequence),
  decreasing = TRUE
)

cat("Top 20 consequências (como aparecem no ClinVar):\n")
top20_consequencias <- head(consequencias_simples, 20)
print(top20_consequencias)

# Exportar resultado
df_consequencias <- data.frame(
  Consequencia = names(top20_consequencias),
  Frequencia = as.numeric(top20_consequencias),
  Percentual = round(as.numeric(top20_consequencias) / sum(consequencias_simples) * 100, 2),
  row.names = NULL,
  stringsAsFactors = FALSE
)

write.csv(df_consequencias, 
          "results/top_consequencias.csv", 
          row.names = FALSE)
cat("✅ Resultados salvos em: results/top_consequencias.csv\n")

# Gráfico 4: Top consequências
png("figures/04_top_consequencias.png", 
    width = 1200, height = 700, res = 100)

top10_consequencias <- head(consequencias_simples, 10)

coord_x <- barplot(
  top10_consequencias,
  main = "Top 10 Consequências Moleculares em MLH1",
  ylab = "Número de registros",
  las = 2,
  cex.names = 0.7,
  col = "purple",
  ylim = c(0, max(top10_consequencias) * 1.15)
)

text(x = coord_x, y = top10_consequencias, 
     labels = top10_consequencias, pos = 3, font = 2)

dev.off()
cat("✅ Gráfico salvo em: figures/04_top_consequencias.png\n")

# ==================================================
# 6. ANÁLISE MOLECULAR - TIPOS DE VARIANTES
# ==================================================

cat("\n=== ANÁLISE MOLECULAR - TIPOS DE VARIANTES ===\n")

tipos_variantes <- c(
  Deleção = sum(grepl("del", clinvar$Name, ignore.case = TRUE)),
  Duplicação = sum(grepl("dup", clinvar$Name, ignore.case = TRUE)),
  Inserção = sum(grepl("ins", clinvar$Name, ignore.case = TRUE)),
  Inversão = sum(grepl("inv", clinvar$Name, ignore.case = TRUE))
)

cat("\nDistribuição de tipos estruturais:\n")
print(tipos_variantes)

cat("\nProporção (%):\n")
tipos_pct <- round(prop.table(tipos_variantes) * 100, 2)
print(tipos_pct)

# ==================================================
# 7. ANÁLISE DE GENES
# ==================================================

cat("\n=== ANÁLISE DE GENES ===\n")

genes <- sort(
  table(clinvar$Gene.s.),
  decreasing = TRUE
)

cat(sprintf("Total de genes únicos no dataset: %d\n", 
            length(unique(clinvar$Gene.s.))))

cat("\nTop 10 genes:\n")
print(head(genes, 10))

# Validação: todos são MLH1?
mlh1_count <- sum(grepl("MLH1", clinvar$Gene.s.))
cat(sprintf("\nVariantes contendo MLH1: %d/%d (%.1f%%)\n", 
            mlh1_count, nrow(clinvar), 
            mlh1_count/nrow(clinvar)*100))

# ==================================================
# 8. RESUMO FINAL
# ==================================================

cat("\n=== RESUMO SCRIPT 03 ===\n")
cat(sprintf("✅ Dataset analisado: %d variantes MLH1\n", nrow(clinvar)))
cat(sprintf("✅ %d colunas processadas\n", ncol(clinvar)))
cat(sprintf("✅ 4 gráficos PNG criados em: figures/\n"))
cat(sprintf("✅ 4 arquivos CSV criados em: results/\n"))
cat("\n✅ SCRIPT 03 EXECUTADO COM SUCESSO!\n")
cat("Próximo passo: Script 04 - Análises Relacionais\n\n")

# ==================================================
# FIM DO SCRIPT 03
# ==================================================