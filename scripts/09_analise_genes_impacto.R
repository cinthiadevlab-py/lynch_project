# ==================================================
# PROJETO LYNCH - SÍNDROME DE LYNCH
# Script 09 - Análise de Genes e Impacto
# ==================================================
#
# OBJETIVO:
# Analisar impacto molecular de variantes por gene
# Classificar severidade clínica
# Identificar genes críticos para Lynch Syndrome
#
# ENTRADA:
# - clinvar_mlh1_com_gnomad.rds (1.739 variantes anotadas)
#
# SAÍDA:
# - Análise de impacto por gene (CSV)
# - Classificações de severidade (CSV)
# - Gráficos de distribuição (PNG)
# - RDS com resultados processados
# ==================================================

# ==================================================
# 1. CARREGAMENTO E VALIDACAO INICIAL
# ==================================================

cat("\n=== INICIANDO SCRIPT 09 ===\n")
cat("Análise de Genes e Impacto\n")
cat("Data:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n\n")

# Validar arquivo de entrada
if (!file.exists("dados_processados/clinvar_mlh1_com_gnomad.rds")) {
  stop("[ERRO] Execute Script 08 primeiro!")
}

cat("Carregando dados processados...\n")
df_gnomad <- readRDS("dados_processados/clinvar_mlh1_com_gnomad.rds")

cat("[OK] Dados carregados com sucesso!\n")
cat(sprintf("   Dimensões: %d linhas x %d colunas\n", 
            nrow(df_gnomad), ncol(df_gnomad)))

# ==================================================
# 2. PASSO 1: ANALISE DE IMPACTO POR GENE
# ==================================================

cat("\n=== PASSO 1: ANALISE DE IMPACTO POR GENE ===\n\n")

# Tabela de frequência por gene e classificação
cat("Criando tabela de contingência (Gene x Classificacao)...\n")

tabela_gene_class <- table(
  Gene = df_gnomad$gene,
  Classificacao = df_gnomad$classificacao_final
)

cat(sprintf("[OK] Tabela criada: %d genes x %d classificações\n\n", 
            nrow(tabela_gene_class), ncol(tabela_gene_class)))

# Converter para dataframe
df_gene_impact <- as.data.frame(tabela_gene_class, stringsAsFactors = FALSE)
names(df_gene_impact) <- c("Gene", "Classificacao", "Frequencia")

# Ordenar por frequência total
df_gene_impact_ordenado <- df_gene_impact[
  order(df_gene_impact$Frequencia, decreasing = TRUE), ]

cat("Top 15 relações Gene x Classificação:\n")
print(head(df_gene_impact_ordenado, 15))

# ==================================================
# 3. PASSO 2: IMPACTO TOTAL POR GENE
# ==================================================

cat("\n=== PASSO 2: IMPACTO TOTAL POR GENE ===\n\n")

# Calcular frequência total por gene
gene_freq <- sort(table(df_gnomad$gene), decreasing = TRUE)

cat(sprintf("Total de genes únicos: %d\n\n", length(gene_freq)))

cat("Top 10 genes por total de variantes:\n")
print(head(gene_freq, 10))

# Criar dataframe com estatísticas por gene
df_gene_stats <- data.frame(
  Gene = names(gene_freq),
  Total_Variantes = as.numeric(gene_freq),
  Percentual = round(as.numeric(gene_freq) / nrow(df_gnomad) * 100, 2),
  row.names = NULL,
  stringsAsFactors = FALSE
)

# Adicionar contagem por classificação
for (gene in df_gene_stats$Gene) {
  pathogenic_count <- sum(df_gnomad$gene == gene & 
                            grepl("Pathogenic", df_gnomad$classificacao_final))
  vus_count <- sum(df_gnomad$gene == gene & 
                     grepl("VUS", df_gnomad$classificacao_final))
  
  df_gene_stats[df_gene_stats$Gene == gene, "Pathogenic"] <- pathogenic_count
  df_gene_stats[df_gene_stats$Gene == gene, "VUS"] <- vus_count
}

cat("\nTop 10 genes com estatísticas:\n")
print(head(df_gene_stats, 10))

# ==================================================
# 4. PASSO 3: CLASSIFICACAO DE SEVERIDADE
# ==================================================

cat("\n=== PASSO 3: CLASSIFICACAO DE SEVERIDADE ===\n\n")

cat("Definindo critérios de severidade por gene:\n")
cat("   Crítico: >= 50% das variantes Pathogenic\n")
cat("   Alto: 25-49% Pathogenic\n")
cat("   Moderado: 10-24% Pathogenic\n")
cat("   Baixo: < 10% Pathogenic\n\n")

# Calcular porcentagem de Pathogenic por gene
df_gene_stats$Pct_Pathogenic <- 
  round(df_gene_stats$Pathogenic / df_gene_stats$Total_Variantes * 100, 2)

# Classificar severidade
df_gene_stats$Severidade <- ifelse(
  df_gene_stats$Pct_Pathogenic >= 50, "Crítico",
  ifelse(df_gene_stats$Pct_Pathogenic >= 25, "Alto",
         ifelse(df_gene_stats$Pct_Pathogenic >= 10, "Moderado", "Baixo")))

cat("Distribuição de severidade:\n")
print(table(df_gene_stats$Severidade))

cat("\nGenes por severidade:\n")
for (sev in c("Crítico", "Alto", "Moderado", "Baixo")) {
  genes_sev <- df_gene_stats[df_gene_stats$Severidade == sev, "Gene"]
  if (length(genes_sev) > 0) {
    cat(sprintf("\n%s (%d genes):\n", sev, length(genes_sev)))
    print(genes_sev)
  }
}

# ==================================================
# 5. PASSO 4: VALIDACAO E EXPORTACAO
# ==================================================

cat("\n=== PASSO 4: VALIDACAO E EXPORTACAO ===\n\n")

# Validações
cat("Validações pré-exportação:\n")
cat(sprintf("   Linhas em df_gene_stats: %d\n", nrow(df_gene_stats)))
cat(sprintf("   Colunas: %d\n", ncol(df_gene_stats)))
cat(sprintf("   Sem NA em Gene: %d\n", sum(!is.na(df_gene_stats$Gene))))
cat(sprintf("   Sem NA em Severidade: %d\n\n", sum(!is.na(df_gene_stats$Severidade))))

# Exportar CSV principal
arquivo_csv_genes <- "results/09_impacto_genes.csv"
write.csv(df_gene_stats, arquivo_csv_genes, row.names = FALSE)

cat(sprintf("[OK] Arquivo CSV exportado: %s\n", arquivo_csv_genes))
tamanho_csv <- file.size(arquivo_csv_genes)
cat(sprintf("    Tamanho: %.2f KB\n", tamanho_csv / 1024))

# Exportar CSV de contingência
arquivo_csv_contingencia <- "results/09_gene_classificacao_contingencia.csv"
write.csv(df_gene_impact_ordenado, arquivo_csv_contingencia, row.names = FALSE)

cat(sprintf("[OK] Tabela de contingência exportada: %s\n", arquivo_csv_contingencia))

# Exportar RDS com objeto completo
arquivo_rds <- "dados_processados/script09_gene_impact_results.rds"
saveRDS(df_gene_stats, arquivo_rds)

cat(sprintf("[OK] RDS exportado: %s\n\n", arquivo_rds))

# ==================================================
# 6. RESUMO FINAL
# ==================================================

cat("=== RESUMO FINAL SCRIPT 09 ===\n\n")

cat(sprintf("Genes analisados: %d\n", nrow(df_gene_stats)))
cat(sprintf("Variantes totais: %d\n", nrow(df_gnomad)))

cat("\nGenes críticos para Lynch Syndrome:\n")
genes_criticos <- df_gene_stats[df_gene_stats$Severidade == "Crítico", 
                                c("Gene", "Total_Variantes", "Pct_Pathogenic")]
if (nrow(genes_criticos) > 0) {
  print(genes_criticos)
} else {
  cat("   Nenhum gene com 100% Pathogenic\n")
}

cat("\nVariantes por severidade:\n")
cat(sprintf("   Crítico: %d\n", sum(df_gene_stats$Pathogenic[
  df_gene_stats$Severidade == "Crítico"]))
)
cat(sprintf("   Alto: %d\n", sum(df_gene_stats$Pathogenic[
  df_gene_stats$Severidade == "Alto"]))
)
cat(sprintf("   Moderado: %d\n", sum(df_gene_stats$Pathogenic[
  df_gene_stats$Severidade == "Moderado"]))
)
cat(sprintf("   Baixo: %d\n", sum(df_gene_stats$Pathogenic[
  df_gene_stats$Severidade == "Baixo"]))
)

cat("\n[OK] SCRIPT 09 EXECUTADO COM SUCESSO!\n")
cat("Próximo: Script 10 - Análise Populacional\n")

# ==================================================
# FIM DO SCRIPT 09
# ==================================================