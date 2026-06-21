# ==================================================
# PROJETO LYNCH - SÍNDROME DE LYNCH
# Script 04 - Separação de Genes Múltiplos
# ==================================================
#
# PROBLEMA IDENTIFICADO (Script 03):
# Coluna Gene.s. contém múltiplos genes: "MLH1|MSH2|BRCA1|..."
# Para análises relacionais (Etapa 5), precisamos separar!
#
# SOLUÇÃO:
# Expandir tabela onde cada gene é uma linha separada
# Permitir análises por gene individual
#
# OUTPUT:
# - dados_processados/clinvar_mlh1_expandido.rds
# - results/genes_individuais.csv
# - figures/05_genes_individuais.png
# ==================================================

# ==================================================
# 1. CARREGAMENTO E VALIDAÇÃO INICIAL
# ==================================================

cat("\n=== INICIANDO SCRIPT 04 ===\n")
cat("Resolvendo problema de genes múltiplos...\n")

# Validar arquivo
if (!file.exists("dados_processados/clinvar_mlh1_limpo.rds")) {
  stop("ERRO: Execute Script 02 primeiro!")
}

# Carregar dados processados
clinvar <- readRDS("dados_processados/clinvar_mlh1_limpo.rds")

cat("Dados carregados!\n")
cat(sprintf("   Dimensões originais: %d linhas × %d colunas\n", 
            nrow(clinvar), ncol(clinvar)))

# ==================================================
# 2. ANÁLISE DO PROBLEMA: Gene.s. COM MÚLTIPLOS GENES
# ==================================================

cat("\n=== DIAGNÓSTICO DO PROBLEMA ===\n")

cat("\nExemplos de Gene.s. (10 primeiros registros):\n")
print(head(clinvar$Gene.s., 10))

# Contar quantos genes cada linha tem
genes_por_linha <- sapply(strsplit(clinvar$Gene.s., "\\|"), length)

cat(sprintf("\nMédia de genes por registro: %.2f\n", mean(genes_por_linha)))
cat(sprintf("Máximo de genes em um registro: %d\n", max(genes_por_linha)))
cat(sprintf("Mínimo de genes em um registro: %d\n", min(genes_por_linha)))

# Distribuição
cat("\nDistribuição de quantos genes por registro:\n")
print(table(genes_por_linha))

# ==================================================
# 3. CRIAR TABELA EXPANDIDA (SOLUÇÃO)
# ==================================================

cat("\n=== EXPANDINDO TABELA ===\n")

cat("Separando genes individuais...\n")

# Expandir linhas: duplicar linhas de acordo com número de genes
clinvar_expandido <- clinvar[rep(seq_len(nrow(clinvar)), genes_por_linha), ]

# Separar genes em coluna nova
clinvar_expandido$Gene_individual <- unlist(
  strsplit(clinvar$Gene.s., "\\|")
)

cat("Tabela expandida criada!\n")
cat(sprintf("   Dimensões expandidas: %d linhas × %d colunas\n", 
            nrow(clinvar_expandido), ncol(clinvar_expandido)))

# ==================================================
# 4. ANÁLISE DE GENES INDIVIDUAIS
# ==================================================

cat("\n=== ANÁLISE DE GENES INDIVIDUAIS ===\n")

# Frequência de cada gene
genes_freq <- sort(
  table(clinvar_expandido$Gene_individual),
  decreasing = TRUE
)

cat(sprintf("\nTotal de genes únicos encontrados: %d\n", 
            length(genes_freq)))

cat("\nTodos os genes (com frequência):\n")
print(genes_freq)

cat("\nProporção (%):\n")
genes_pct <- round(prop.table(genes_freq) * 100, 2)
print(genes_pct)

# ==================================================
# 5. VALIDAÇÃO: MLH1 DEVE TER 100%
# ==================================================

cat("\n=== VALIDAÇÃO CRÍTICA ===\n")

mlh1_expandido <- sum(grepl("MLH1", clinvar_expandido$Gene_individual))
total_expandido <- nrow(clinvar_expandido)

cat(sprintf("MLH1 aparece em: %d/%d registros expandidos\n", 
            mlh1_expandido, total_expandido))
cat(sprintf("Percentual: %.2f%%\n", 
            mlh1_expandido/total_expandido*100))

# Esse número NÃO será 100% porque algumas variantes afetam outros genes
# MAS deve estar em ~99%+ dos registros

if (mlh1_expandido >= 1700) {
  cat("VALIDAÇÃO PASSOU: MLH1 está em quase todos os registros!\n")
} else {
  cat("AVISO: MLH1 está em menos registros que esperado\n")
}

# ==================================================
# 6. EXPORTAR RESULTADOS
# ==================================================

cat("\n=== EXPORTANDO RESULTADOS ===\n")

# Exportar CSV com frequências de genes
df_genes <- data.frame(
  Gene = names(genes_freq),
  Frequencia_afetacoes = as.numeric(genes_freq),
  Percentual = as.numeric(genes_pct),
  row.names = NULL,
  stringsAsFactors = FALSE
)

write.csv(df_genes, 
          "results/genes_individuais.csv", 
          row.names = FALSE)

cat("Genes salvos em: results/genes_individuais.csv\n")
cat(sprintf("   Total de genes: %d linhas\n", nrow(df_genes)))

# ==================================================
# 7. GRÁFICO: TOP 15 GENES
# ==================================================

cat("\nCriando gráfico de genes mais frequentes...\n")

png("figures/05_genes_individuais.png", 
    width = 1000, height = 700, res = 100)

top15_genes <- head(genes_freq, 15)

coord_x <- barplot(
  top15_genes,
  main = "Top 15 Genes Afetados por Variantes do Dataset",
  ylab = "Número de afetações",
  las = 2,
  cex.names = 0.75,
  col = "steelblue",
  ylim = c(0, max(top15_genes) * 1.15)
)

text(x = coord_x, y = top15_genes, 
     labels = top15_genes, pos = 3, font = 2)

dev.off()

cat("Gráfico salvo em: figures/05_genes_individuais.png\n")

# ==================================================
# 8. SALVAR TABELA EXPANDIDA
# ==================================================

cat("\nSalvando tabela expandida em RDS...\n")

saveRDS(clinvar_expandido, 
        "dados_processados/clinvar_mlh1_expandido.rds")

if (file.exists("dados_processados/clinvar_mlh1_expandido.rds")) {
  tamanho <- file.size("dados_processados/clinvar_mlh1_expandido.rds")
  cat(sprintf("Arquivo salvo com sucesso!\n"))
  cat(sprintf("   Localização: dados_processados/clinvar_mlh1_expandido.rds\n"))
  cat(sprintf("   Tamanho: %.2f KB\n", tamanho / 1024))
} else {
  stop("ERRO: Falha ao salvar arquivo RDS!")
}

# ==================================================
# 9. RESUMO COMPARATIVO
# ==================================================

cat("\n=== RESUMO COMPARATIVO ===\n")

cat("\nDADOS ORIGINAIS (Script 03):\n")
cat(sprintf("   Linhas: %d registros\n", nrow(clinvar)))
cat(sprintf("   Gene.s.: %d combinações únicas\n", 
            length(unique(clinvar$Gene.s.))))
cat(sprintf("   Problema: Genes misturados em uma célula\n"))

cat("\nDADOS EXPANDIDOS (Script 04):\n")
cat(sprintf("   Linhas: %d registros (expandido)\n", 
            nrow(clinvar_expandido)))
cat(sprintf("   Genes individuais: %d únicos\n", 
            length(genes_freq)))
cat(sprintf("   Solução: Cada gene em linha separada\n"))

cat("\nTOP 5 GENES MAIS FREQUENTES:\n")
top5 <- head(genes_freq, 5)
for (i in seq_along(top5)) {
  pct <- genes_pct[i]
  cat(sprintf("   %d. %s: %d afetações (%.2f%%)\n", 
              i, names(top5)[i], top5[i], pct))
}

# ==================================================
# 10. PRÓXIMO PASSO
# ==================================================

cat("\n=== PRÓXIMO PASSO ===\n")

cat("\nScript 04 concluído com sucesso!\n")
cat("Problema de genes múltiplos RESOLVIDO!\n")
cat("Dados agora prontos para análises relacionais\n\n")
cat("Agora você pode usar:\n")
cat("   - clinvar_mlh1_expandido.rds (para análises por gene)\n")
cat("   - genes_individuais.csv (referência)\n")
cat("   - 05_genes_individuais.png (visualização)\n\n")
cat("Próximo: Script 05 - Análises Relacionais\n")
cat("(usando a tabela expandida para cruzamentos!)\n")

# ==================================================
# FIM DO SCRIPT 04
# ==================================================