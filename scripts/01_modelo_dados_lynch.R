# ==================================================
# PROJETO LYNCH - SÍNDROME DE LYNCH
# Script 01 - Modelagem da estrutura de dados
# ==================================================
# 
# OBJETIVO:
# Definir a estrutura de dados para análise de variantes
# genéticas associadas à Síndrome de Lynch
#
# GENES MMR CLÁSSICOS:
# MLH1, MSH2, MSH6, PMS2, EPCAM
# ==================================================

# ==================================================
# 1. GENES CLÁSSICOS ASSOCIADOS À SÍNDROME DE LYNCH
# ==================================================

genes_mmr <- c(
  "MLH1",   # Mismatch Repair protein MLH1 - gene principal
  "MSH2",   # Mismatch Recognition Protein MSH2
  "MSH6",   # Mismatch Recognition Protein MSH6
  "PMS2",   # Post-Meiotic Segregation Increased 2
  "EPCAM"   # Epithelial Cell Adhesion Molecule (rare)
)

# ==================================================
# 2. ESTRUTURA - COORTE CLÍNICA
# ==================================================
# Cada linha = um paciente
# Variáveis clínicas, demográficas e genotípicas

colunas_coorte <- c(
  "paciente_id",         # ID único do paciente
  "idade",               # Idade na primeira avaliação
  "sexo",                # Sexo biológico (M/F)
  "tumor",               # Tipo de tumor desenvolvido
  "gene",                # Gene MMR afetado (MLH1, MSH2, etc)
  "variante",            # Variante genética (nomenclatura HGVS)
  "classificacao_acmg",  # Classificação ACMG/AMP 2015
  "msi",                 # MSI status (Microsatellite Instability: MSI-H, MSI-L, MSS)
  "ihc",                 # IHC status (Immunohistochemistry: Loss, Normal)
  "data_diagnostico"     # Data do diagnóstico clínico
)

# ==================================================
# 3. ESTRUTURA - BANCO DE VARIANTES
# ==================================================
# Cada linha = uma variante genética
# Informações sobre variantes de interesse clínico

colunas_variantes <- c(
  "gene",                      # Gene MMR afetado
  "variante",                  # Designação HGVS completa
  "classificacao_acmg",        # Classificação ACMG/AMP 2015
  "clinvar_id",                # ID único do ClinVar (VariationID)
  "classificacao_insight",     # Classificação do banco InSiGHT
  "consequencia_molecular",    # Tipo de consequência molecular (frameshift, nonsense, splice, missense, etc)
  "tipo_variante",             # Tipo estrutural (SNV, Deletion, Duplication, Insertion, Indel)
  "frequencia_gnomad",         # Frequência em população (gnomAD)
  "literatura"                 # Referências bibliográficas encontradas
)

# ==================================================
# 4. FONTES DE DADOS
# ==================================================
# Bancos de dados públicos utilizados

fontes_dados <- c(
  "ClinVar"    # NCBI Variant Database (https://www.ncbi.nlm.nih.gov/clinvar/)
  # "InSiGHT"  # Lynch-specific variants (futuro)
  # "gnomAD"   # Population frequencies (futuro)
)

# ==================================================
# 5. CRIAR DATA FRAMES VAZIOS (ESTRUTURA)
# ==================================================

# Coorte clínica (estrutura)
coorte_lynch <- data.frame(
  paciente_id = character(),
  idade = numeric(),
  sexo = character(),
  tumor = character(),
  gene = character(),
  variante = character(),
  classificacao_acmg = factor(
    levels = c("Pathogenic", "Likely Pathogenic", "VUS", 
               "Likely Benign", "Benign")
  ),
  msi = factor(levels = c("MSI-H", "MSI-L", "MSS")),
  ihc = factor(levels = c("Loss", "Normal", "Unknown")),
  data_diagnostico = as.Date(character()),
  stringsAsFactors = FALSE
)

# Banco de variantes (estrutura)
banco_variantes <- data.frame(
  gene = character(),
  variante = character(),
  classificacao_acmg = factor(
    levels = c("Pathogenic", "Likely Pathogenic", "VUS", 
               "Likely Benign", "Benign")
  ),
  clinvar_id = character(),
  classificacao_insight = character(),
  consequencia_molecular = character(),
  tipo_variante = character(),
  frequencia_gnomad = numeric(),
  literatura = character(),
  stringsAsFactors = FALSE
)

# ==================================================
# 6. VALIDAÇÃO E CONFIRMAÇÃO
# ==================================================

# Verificar estrutura da coorte
cat("\n=== ESTRUTURA COORTE CLÍNICA ===\n")
print(str(coorte_lynch))
cat("Dimensões:", nrow(coorte_lynch), "linhas x", ncol(coorte_lynch), "colunas\n")

# Verificar estrutura do banco de variantes
cat("\n=== ESTRUTURA BANCO DE VARIANTES ===\n")
print(str(banco_variantes))
cat("Dimensões:", nrow(banco_variantes), "linhas x", ncol(banco_variantes), "colunas\n")

# Confirmação final
cat("\n✅ Script 01 executado com sucesso!")
cat("\n✅ Estruturas de dados criadas e validadas")
cat("\nPróximo passo: Script 02 - Importação de dados ClinVar\n")

# ==================================================
# FIM DO SCRIPT 01
# ==================================================