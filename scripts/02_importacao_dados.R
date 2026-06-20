# ==================================================
# IMPORTAÇÃO DE DADOS
# ==================================================

# Projeto:
# Síndrome de Lynch
#
# Objetivo:
# Importar variantes reais de bancos públicos
#
# Fonte de dados utilizada nesta etapa:
# - ClinVar

# ==================================================
# PACOTES NECESSÁRIOS
# ==================================================

# Instalar pacotes (executar apenas uma vez)

# install.packages("readr") 
# install.packages("dplyr")

# Carregar pacotes

library(readr)
library(dplyr) 

# ==========================================
# IMPORTAR DADOS CLINVAR
# ==========================================

clinvar_mlh1 <- read.delim(
  "dados_brutos/insight/clinvar_mlh1_patogenicas_2026.txt",
  sep = "\t",
  header = TRUE,
  stringsAsFactors = FALSE
)

View(clinvar_mlh1) 

names(clinvar_mlh1) 
names(clinvar_mlh1)[1:12]
data.frame(
  numero = 1:length(names(clinvar_mlh1)),
  coluna = names(clinvar_mlh1)
)

clinvar_limpo <- clinvar_mlh1 %>%
  select(
    Name,
    Gene.s.,
    Protein.change,
    Condition.s.,
    Molecular.consequence,
    Germline.classification,
    Germline.review.status,
    VariationID,
    AlleleID.s.,
    dbSNP.ID
  ) 
dim(clinvar_limpo)

nrow(clinvar_limpo)

ncol(clinvar_limpo)

View(clinvar_limpo)
table(clinvar_limpo$Germline.classification)
table(clinvar_limpo$Molecular.consequence)
head(
  sort(
    table(clinvar_limpo$Molecular.consequence),
    decreasing = TRUE
  ),
  20
) 
summary(clinvar_limpo) 
sum(grepl("MLH1", clinvar_limpo$Gene.s.)) 
sum(!grepl("MLH1", clinvar_limpo$Gene.s.)) 

table(clinvar_limpo$Germline.review.status) 
length(unique(clinvar_limpo$VariationID)) 
saveRDS(
  clinvar_limpo,
  "dados_processados/clinvar_mlh1_limpo.rds"
)