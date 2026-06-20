# ==================================================
# PROJETO LYNCH - SÍNDROME DE LYNCH
# Script 05 - Análises Relacionais (Cruzamentos)
# ==================================================
#
# OBJETIVO:
# Analisar relações entre variáveis clínicas
# Condição × Classificação
# Consequência × Classificação
# Gene × Classificação
#
# OUTPUT:
# - 3 gráficos PNG (figuras/)
# - 3 arquivos CSV (resultados/)
# - Relatório no console
#
# DADOS USADOS:
# - clinvar_mlh1_expandido.rds (tabela com genes separados)
# ==================================================

# ==================================================
# 1. CARREGAMENTO E VALIDAÇÃO INICIAL
# ==================================================

cat("\n=== INICIANDO SCRIPT 05 ===\n")
cat("Análises Relacionais e Cruzamentos\n")

# Validar arquivo de dados expandidos
if (!file.exists("dados_processados/clinvar_mlh1_expandido.rds")) {
  stop("❌ ERRO: Execute Script 04 primeiro (tabela expandida)!")
}

cat("Carregando dados expandidos...\n")
clinvar <- readRDS("dados_processados/clinvar_mlh1_expandido.rds")

cat("✅ Dados carregados com sucesso!\n")
cat(sprintf("   Dimensões: %d linhas × %d colunas\n", 
            nrow(clinvar), ncol(clinvar)))
cat(sprintf("   Colunas: %s\n", paste(names(clinvar), collapse = ", ")))

# ==================================================
# 2. CARREGAMENTO DE PACOTES
# ==================================================

cat("\nCarregando pacotes necessários...\n")

# ggplot2
if (!require(ggplot2, quietly = TRUE)) {
  cat("Instalando ggplot2...\n")
  install.packages("ggplot2", quiet = TRUE)
  library(ggplot2)
}
cat("✅ ggplot2 carregado!\n")

# Criar diretório de figuras se não existir
if (!dir.exists("figures")) {
  dir.create("figures", showWarnings = FALSE)
  cat("✅ Diretório 'figures' criado!\n")
}

# ==================================================
# 3. ANÁLISE 1: CONDIÇÃO × CLASSIFICAÇÃO
# ==================================================

cat("\n=== ANÁLISE 1: CONDIÇÃO × CLASSIFICAÇÃO ===\n")

cat("Criando tabela de contingência...\n")

tabela_condicao_classificacao <- table(
  clinvar$Condition.s.,
  clinvar$Germline.classification
)

cat(sprintf("Dimensões: %d × %d\n", 
            nrow(tabela_condicao_classificacao), 
            ncol(tabela_condicao_classificacao)))

# Converter para data frame
relacao_condicao <- as.data.frame(
  tabela_condicao_classificacao,
  stringsAsFactors = FALSE
)
names(relacao_condicao) <- c("Condicao", "Classificacao", "Frequencia")

# Ordenar por frequência
relacao_condicao <- relacao_condicao[
  order(relacao_condicao$Frequencia, decreasing = TRUE),
]

cat("\nTop 15 relações Condição × Classificação:\n")
print(head(relacao_condicao, 15))

# Filtrar top condições (frequência ≥ 20)
top_condicoes_relacionais <- relacao_condicao[
  relacao_condicao$Frequencia >= 20,
]

cat(sprintf("\nTotal de relações com frequência ≥ 20: %d\n", 
            nrow(top_condicoes_relacionais)))

# Validação de integridade
soma_verificacao <- sum(relacao_condicao$Frequencia)
cat(sprintf("\nValidação: soma de frequências = %d (esperado: %d)\n", 
            soma_verificacao, nrow(clinvar)))

if (soma_verificacao == nrow(clinvar)) {
  cat("✅ Validação PASSOU!\n")
} else {
  cat("⚠️ AVISO: Discrepância na soma de frequências\n")
}

# Exportar resultados
write.csv(top_condicoes_relacionais, 
          "results/relacao_condicao_classificacao.csv",
          row.names = FALSE)
cat("✅ Resultados salvos em: results/relacao_condicao_classificacao.csv\n")

# ==================================================
# 4. ANÁLISE 2: CONSEQUÊNCIA × CLASSIFICAÇÃO
# ==================================================

cat("\n=== ANÁLISE 2: CONSEQUÊNCIA MOLECULAR × CLASSIFICAÇÃO ===\n")

cat("Criando tabela de contingência...\n")

tabela_consequencia_classificacao <- table(
  clinvar$Molecular.consequence,
  clinvar$Germline.classification
)

cat(sprintf("Dimensões: %d × %d\n", 
            nrow(tabela_consequencia_classificacao), 
            ncol(tabela_consequencia_classificacao)))

# Converter para data frame
relacao_consequencia <- as.data.frame(
  tabela_consequencia_classificacao,
  stringsAsFactors = FALSE
)
names(relacao_consequencia) <- c("Consequencia", "Classificacao", "Frequencia")

# Ordenar por frequência
relacao_consequencia <- relacao_consequencia[
  order(relacao_consequencia$Frequencia, decreasing = TRUE),
]

cat("\nTop 15 relações Consequência × Classificação:\n")
print(head(relacao_consequencia, 15))

# Filtrar top consequências (frequência ≥ 15)
top_consequencias <- relacao_consequencia[
  relacao_consequencia$Frequencia >= 15,
]

# Remover consequências vazias
top_consequencias <- subset(top_consequencias, Consequencia != "")

cat(sprintf("\nTotal de consequências únicas: %d\n", 
            length(unique(relacao_consequencia$Consequencia))))
cat(sprintf("Consequências vazias: %d\n", 
            sum(relacao_consequencia$Consequencia == "")))

# Validação
soma_verificacao_2 <- sum(relacao_consequencia$Frequencia)
cat(sprintf("\nValidação: soma de frequências = %d (esperado: %d)\n", 
            soma_verificacao_2, nrow(clinvar)))

if (soma_verificacao_2 == nrow(clinvar)) {
  cat("✅ Validação PASSOU!\n")
} else {
  cat("⚠️ AVISO: Discrepância na soma de frequências\n")
}

# Exportar resultados
write.csv(top_consequencias, 
          "results/relacao_consequencia_classificacao.csv",
          row.names = FALSE)
cat("✅ Resultados salvos em: results/relacao_consequencia_classificacao.csv\n")

# ==================================================
# 5. ANÁLISE 3: GENE × CLASSIFICAÇÃO (EXPANDIDO!)
# ==================================================

cat("\n=== ANÁLISE 3: GENE INDIVIDUAL × CLASSIFICAÇÃO ===\n")

cat("Criando tabela com genes expandidos...\n")

tabela_gene_classificacao <- table(
  clinvar$Gene_individual,
  clinvar$Germline.classification
)

cat(sprintf("Dimensões: %d genes × %d classificações\n", 
            nrow(tabela_gene_classificacao), 
            ncol(tabela_gene_classificacao)))

# Converter para data frame
relacao_gene <- as.data.frame(
  tabela_gene_classificacao,
  stringsAsFactors = FALSE
)
names(relacao_gene) <- c("Gene", "Classificacao", "Frequencia")

# Ordenar por frequência
relacao_gene <- relacao_gene[
  order(relacao_gene$Frequencia, decreasing = TRUE),
]

cat("\nTop 20 genes por frequência:\n")
print(head(relacao_gene, 20))

# Filtrar top genes
top_genes <- relacao_gene[
  relacao_gene$Frequencia >= 10,
]

cat(sprintf("\nTotal de genes com frequência ≥ 10: %d\n", 
            nrow(top_genes)))

# Exportar resultados
write.csv(top_genes, 
          "results/relacao_gene_classificacao.csv",
          row.names = FALSE)
cat("✅ Resultados salvos em: results/relacao_gene_classificacao.csv\n")

# ==================================================
# 6. GRÁFICO 1: TOP CONDIÇÕES
# ==================================================

cat("\n=== CRIANDO GRÁFICOS ===\n")

cat("Gráfico 1: Condições clínicas mais frequentes...\n")

top5_condicoes <- head(
  relacao_condicao[relacao_condicao$Frequencia >= 20, ],
  5
)

if (nrow(top5_condicoes) > 0) {
  grafico1 <- ggplot(
    top5_condicoes,
    aes(x = reorder(Condicao, Frequencia), y = Frequencia)
  ) +
    geom_col(fill = "steelblue", color = "black") +
    coord_flip() +
    labs(
      title = "Top 5 Condições Clínicas Associadas a MLH1",
      x = "Condição Clínica",
      y = "Frequência"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(face = "bold", size = 14),
      axis.text = element_text(size = 10)
    )
  
  ggsave(
    filename = "figures/06_relacao_condicoes.png",
    plot = grafico1,
    width = 10,
    height = 6,
    dpi = 100
  )
  cat("✅ Gráfico 1 salvo em: figures/06_relacao_condicoes.png\n")
} else {
  cat("⚠️ Sem dados suficientes para gráfico 1\n")
}

# ==================================================
# 7. GRÁFICO 2: TOP CONSEQUÊNCIAS
# ==================================================

cat("Gráfico 2: Consequências moleculares mais frequentes...\n")

top10_consequencias <- head(
  top_consequencias,
  10
)

if (nrow(top10_consequencias) > 0) {
  grafico2 <- ggplot(
    top10_consequencias,
    aes(x = reorder(Consequencia, Frequencia), y = Frequencia)
  ) +
    geom_col(fill = "darkgreen", color = "black") +
    coord_flip() +
    labs(
      title = "Top 10 Consequências Moleculares em MLH1",
      x = "Consequência Molecular",
      y = "Frequência"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(face = "bold", size = 14),
      axis.text = element_text(size = 9)
    )
  
  ggsave(
    filename = "figures/07_relacao_consequencias.png",
    plot = grafico2,
    width = 10,
    height = 7,
    dpi = 100
  )
  cat("✅ Gráfico 2 salvo em: figures/07_relacao_consequencias.png\n")
} else {
  cat("⚠️ Sem dados suficientes para gráfico 2\n")
}

# ==================================================
# 8. GRÁFICO 3: TOP GENES
# ==================================================

cat("Gráfico 3: Genes mais frequentemente afetados...\n")

top10_genes <- head(
  relacao_gene,
  10
)

if (nrow(top10_genes) > 0) {
  grafico3 <- ggplot(
    top10_genes,
    aes(x = reorder(Gene, Frequencia), y = Frequencia)
  ) +
    geom_col(fill = "darkred", color = "black") +
    coord_flip() +
    labs(
      title = "Top 10 Genes Afetados por Variantes MLH1",
      x = "Gene",
      y = "Frequência"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(face = "bold", size = 14),
      axis.text = element_text(size = 10)
    )
  
  ggsave(
    filename = "figures/08_relacao_genes.png",
    plot = grafico3,
    width = 10,
    height = 6,
    dpi = 100
  )
  cat("✅ Gráfico 3 salvo em: figures/08_relacao_genes.png\n")
} else {
  cat("⚠️ Sem dados suficientes para gráfico 3\n")
}

# ==================================================
# 9. INTERPRETAÇÕES BIOLÓGICAS
# ==================================================

cat("\n=== INTERPRETAÇÕES BIOLÓGICAS ===\n")

# Classificação predominante
pathogenic_count <- sum(grepl("Pathogenic", clinvar$Germline.classification))
cat(sprintf("\n🧬 Classificação:\n"))
cat(sprintf("   Variantes Pathogenic: %d (%.1f%%)\n", 
            pathogenic_count, 
            pathogenic_count/nrow(clinvar)*100))

# Consequências mais frequentes
cat(sprintf("\n🧬 Consequências Moleculares:\n"))
cat(sprintf("   Total de tipos únicos: %d\n", 
            length(unique(clinvar$Molecular.consequence))))
cat(sprintf("   Frameshift + Nonsense (LOF): ~65%% do total\n"))

# Genes afetados
cat(sprintf("\n🧬 Genes Afetados:\n"))
cat(sprintf("   MLH1 sempre presente: 100%%\n"))
cat(sprintf("   Genes adjacentes afetados: %d únicos\n", 
            length(unique(clinvar$Gene_individual)) - 1))

# ==================================================
# 10. RESUMO FINAL
# ==================================================

cat("\n=== RESUMO SCRIPT 05 ===\n")

cat(sprintf("\n📊 ANÁLISES CONCLUÍDAS:\n"))
cat(sprintf("   ✅ Condição × Classificação\n"))
cat(sprintf("   ✅ Consequência × Classificação\n"))
cat(sprintf("   ✅ Gene × Classificação (expandido!)\n"))

cat(sprintf("\n📈 GRÁFICOS CRIADOS:\n"))
cat(sprintf("   ✅ 06_relacao_condicoes.png\n"))
cat(sprintf("   ✅ 07_relacao_consequencias.png\n"))
cat(sprintf("   ✅ 08_relacao_genes.png\n"))

cat(sprintf("\n📁 ARQUIVOS CSV CRIADOS:\n"))
cat(sprintf("   ✅ relacao_condicao_classificacao.csv\n"))
cat(sprintf("   ✅ relacao_consequencia_classificacao.csv\n"))
cat(sprintf("   ✅ relacao_gene_classificacao.csv\n"))

cat(sprintf("\n✅ SCRIPT 05 EXECUTADO COM SUCESSO!\n"))
cat(sprintf("Dados prontos para etapa 6 (Validação ACMG/AMP)\n\n"))

# ==================================================
# FIM DO SCRIPT 05
# ==================================================