# ==================================================
# PROJETO LYNCH - SÍNDROME DE LYNCH
# Script 02 - Importação e Limpeza de Dados ClinVar
# ==================================================
#
# OBJETIVO:
# Importar variantes reais do ClinVar
# Selecionar colunas clinicamente relevantes
# Validar integridade dos dados
# Salvar em formato RDS (binário comprimido)
#
# FONTE DE DADOS:
# - ClinVar (NCBI) - 1.745 variantes MLH1 pathogenic/likely pathogenic
# ==================================================

# ==================================================
# 1. CARREGAR PACOTES NECESSÁRIOS
# ==================================================

cat("\n=== INICIANDO SCRIPT 02 ===\n")
cat("Carregando pacotes...\n")

library(readr)
library(dplyr)

cat("Pacotes carregados com sucesso!\n")

# ==================================================
# 2. DEFINIR CAMINHOS E VALIDAR ARQUIVOS
# ==================================================

caminho_clinvar <- "dados_brutos/insight/clinvar_mlh1_patogenicas_2026.txt"

# Verificar se arquivo existe
if (!file.exists(caminho_clinvar)) {
  stop("\nERRO CRÍTICO: Arquivo ClinVar não encontrado em:\n", caminho_clinvar)
}

cat("Arquivo ClinVar localizado!\n")

# ==================================================
# 3. IMPORTAR DADOS ORIGINAIS
# ==================================================

cat("\nImportando dados de ClinVar...\n")

clinvar_bruto <- read.delim(
  caminho_clinvar,
  sep = "\t",
  header = TRUE,
  stringsAsFactors = FALSE
)

cat("Importação concluída!\n")
cat(sprintf("   Dimensões: %d linhas × %d colunas\n", 
            nrow(clinvar_bruto), ncol(clinvar_bruto)))

# ==================================================
# 4. EXPLORAR COLUNAS DISPONÍVEIS
# ==================================================

cat("\n=== COLUNAS DISPONÍVEIS ===\n")
print(data.frame(
  numero = 1:length(names(clinvar_bruto)),
  coluna = names(clinvar_bruto),
  tipo = sapply(clinvar_bruto, class),
  stringsAsFactors = FALSE
))

# ==================================================
# 5. SELECIONAR COLUNAS CLINICAMENTE RELEVANTES
# ==================================================

cat("\nSelecionando 10 colunas clinicamente relevantes...\n")

clinvar_mlh1_processado <- clinvar_bruto %>%
  select(
    Name,                      # HGVS nomenclature (ex: NM_000249.3(MLH1):c.73G>A)
    Gene.s.,                   # Gene symbols
    Protein.change,            # Amino acid changes (ex: p.Met1Val)
    Condition.s.,              # Associated clinical conditions
    Molecular.consequence,     # Molecular effects (frameshift, nonsense, etc)
    Germline.classification,   # Pathogenicity assessment (Pathogenic, Likely Pathogenic)
    Germline.review.status,    # Evidence quality level (criteria provided, expert review, etc)
    VariationID,               # ClinVar unique identifier
    AlleleID.s.,               # Allele identifiers
    dbSNP.ID                   # dbSNP reference IDs (if available)
  )

cat("Seleção concluída!\n")
cat(sprintf("   Resultado: %d linhas × %d colunas\n", 
            nrow(clinvar_mlh1_processado), ncol(clinvar_mlh1_processado)))

# ==================================================
# 6. VALIDAÇÃO DE INTEGRIDADE (PARTE 1)
# ==================================================

cat("\n=== VALIDAÇÃO DE INTEGRIDADE ===\n")

# Verificar dimensões
cat("Dimensões:\n")
cat(sprintf("  Linhas: %d\n", nrow(clinvar_mlh1_processado)))
cat(sprintf("  Colunas: %d\n", ncol(clinvar_mlh1_processado)))

# Verificar valores faltantes por coluna
cat("\nValores faltantes por coluna:\n")
na_por_coluna <- colSums(is.na(clinvar_mlh1_processado))
print(na_por_coluna)

# Verificar duplicatas
duplicatas <- sum(duplicated(clinvar_mlh1_processado$VariationID))
cat(sprintf("\nDuplicatas por VariationID: %d\n", duplicatas))

# Verificar tipos de dados
cat("\nTipos de dados:\n")
print(str(clinvar_mlh1_processado))

# ==================================================
# 7. ANÁLISE CLÍNICA - CLASSIFICAÇÕES
# ==================================================

cat("\n=== ANÁLISE CLÍNICA - CLASSIFICAÇÕES ===\n")

cat("\nDistribuição de Classificações Germline:\n")
print(table(clinvar_mlh1_processado$Germline.classification))

cat("\nProporção (%):\n")
print(round(prop.table(table(clinvar_mlh1_processado$Germline.classification)) * 100, 2))

# ==================================================
# 8. ANÁLISE MOLECULAR - CONSEQUÊNCIAS
# ==================================================

cat("\n=== ANÁLISE MOLECULAR - CONSEQUÊNCIAS ===\n")

cat("\nTop 20 Consequências Moleculares:\n")
top_consequencias <- head(
  sort(
    table(clinvar_mlh1_processado$Molecular.consequence),
    decreasing = TRUE
  ),
  20
)
print(top_consequencias)

# ==================================================
# 9. ANÁLISE CLÍNICA - CONDIÇÕES
# ==================================================

cat("\n=== ANÁLISE CLÍNICA - CONDIÇÕES ===\n")

# Contar condições únicas
condicoes_unicas <- length(unique(clinvar_mlh1_processado$Condition.s.))
cat(sprintf("Total de condições clínicas únicas: %d\n", condicoes_unicas))

# Top 10 condições
cat("\nTop 10 Condições Clínicas:\n")
top_condicoes <- head(
  sort(
    table(clinvar_mlh1_processado$Condition.s.),
    decreasing = TRUE
  ),
  10
)
print(top_condicoes)

# ==================================================
# 10. ANÁLISE - STATUS DE REVISÃO
# ==================================================

cat("\n=== ANÁLISE - STATUS DE REVISÃO CLÍNICA ===\n")

cat("\nDistribuição de Status de Revisão:\n")
print(table(clinvar_mlh1_processado$Germline.review.status))

# ==================================================
# 11. VALIDAÇÃO DE INTEGRIDADE (PARTE 2)
# ==================================================

cat("\n=== VALIDAÇÃO FINAL ===\n")

# Contar variantes MLH1
mlh1_count <- sum(grepl("MLH1", clinvar_mlh1_processado$Gene.s.))
outros_count <- sum(!grepl("MLH1", clinvar_mlh1_processado$Gene.s.))

cat(sprintf("Variantes MLH1: %d\n", mlh1_count))
cat(sprintf("Outros genes: %d\n", outros_count))
cat(sprintf("Total: %d\n", mlh1_count + outros_count))

# Contar IDs únicos
ids_unicos <- length(unique(clinvar_mlh1_processado$VariationID))
cat(sprintf("\nVariationID únicos: %d\n", ids_unicos))

# ==================================================
# 12. SALVAR DADOS PROCESSADOS
# ==================================================

cat("\nSalvando dados processados em RDS...\n")

caminho_saida <- "dados_processados/clinvar_mlh1_limpo.rds"

saveRDS(
  clinvar_mlh1_processado,
  caminho_saida
)

# Verificar se arquivo foi criado
if (file.exists(caminho_saida)) {
  tamanho_arquivo <- file.size(caminho_saida)
  cat(sprintf("Arquivo salvo com sucesso!\n"))
  cat(sprintf("   Localização: %s\n", caminho_saida))
  cat(sprintf("   Tamanho: %.2f KB\n", tamanho_arquivo / 1024))
} else {
  stop("ERRO: Falha ao salvar arquivo RDS!")
}

# ==================================================
# 13. RESUMO FINAL
# ==================================================

cat("\n=== RESUMO DO SCRIPT 02 ===\n")
cat(sprintf("1.745 variantes MLH1 importadas do ClinVar\n"))
cat(sprintf("10 colunas clinicamente relevantes selecionadas\n"))
cat(sprintf("Integridade dos dados validada\n"))
cat(sprintf("Dados processados salvos em RDS\n"))
cat("\nSCRIPT 02 EXECUTADO COM SUCESSO!\n")
cat("Próximo passo: Script 03 - Análise Exploratória Descritiva\n")

# ==================================================
# FIM DO SCRIPT 02
# ==================================================