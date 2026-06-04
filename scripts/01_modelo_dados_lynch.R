# ==================================================
# PROJETO LYNCH
# Modelagem da estrutura de dados
# ==================================================

# Genes MMR avaliados

genes_mmr <- c(
  "MLH1",
  "MSH2",
  "MSH6",
  "PMS2",
  "EPCAM"
)

# ==================================================
# ESTRUTURA DO PROJETO
# ==================================================

# Tabela 1
# Coorte clínica

# Tabela 2
# Banco de variantes

# Variáveis previstas na coorte

colunas_coorte <- c(
  "paciente_id",
  "idade",
  "sexo",
  "tumor",
  "gene",
  "variante",
  "classificacao_acmg",
  "msi",
  "ihc"
) 

colunas_variantes <- c(
  "gene",
  "variante",
  "classificacao_acmg",
  "clinvar",
  "classificacao_insight",
  "impacto_proteico",
  "literatura"
)

# Fontes de dados do projeto

fontes_dados <- c(
  "InSiGHT",
  "ClinVar"
) 

# ==================================================
# ESTRUTURA DA TABELA PRINCIPAL
# ==================================================

# Cada linha representa um paciente

coorte_lynch <- data.frame(
  paciente_id = character(),
  idade = numeric(),
  sexo = character(),
  tumor = character(),
  gene = character(),
  variante = character(),
  classificacao_acmg = character(),
  msi = character(),
  ihc = character()
)

# ==================================================
# BANCO DE VARIANTES
# ==================================================

banco_variantes <- data.frame(
  gene = character(),
  variante = character(),
  classificacao_acmg = character(),
  clinvar = character(),
  classificacao_insight = character(),
  impacto_proteico = character(),
  literatura = character()
)