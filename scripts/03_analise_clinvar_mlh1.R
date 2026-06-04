# =====================================================
# ANALISE CLINVAR - MLH1
# =====================================================

clinvar <- readRDS(
  "dados_processados/clinvar_mlh1_limpo.rds"
)
dim(clinvar) 
names(clinvar) 
table(clinvar$Germline.classification) 
prop.table(
  table(clinvar$Germline.classification)
)
head(
  sort(
    table(clinvar$Molecular.consequence),
    decreasing = TRUE
  ),
  20
)

head(
  sort(
    table(clinvar$Molecular.consequence),
    decreasing = TRUE
  ),
  10
)

head(
  sort(
    table(clinvar$Gene.s.),
    decreasing = TRUE
  ),
  20
)
length(unique(clinvar$Gene.s.)) 
prop.table(
  table(clinvar$Molecular.consequence)
)

head(
  sort(
    prop.table(
      table(clinvar$Molecular.consequence)
    ),
    decreasing = TRUE
  ),
  20
)

top20 <- head(
  sort(
    prop.table(
      table(clinvar$Molecular.consequence)
    ),
    decreasing = TRUE
  ),
  20
)

round(top20 * 100, 2)

top20
View(as.data.frame(top20))
table(clinvar$Germline.review.status)

round(
  prop.table(
    table(clinvar$Germline.review.status)
  ) * 100,
  2
)

head(
  sort(
    table(clinvar$Condition.s.),
    decreasing = TRUE
  ),
  20
) 

table(clinvar$Gene.s.)

round(
  prop.table(
    table(clinvar$Gene.s.)
  ) * 100,
  2
)

head(clinvar$Gene.s., 20)
length(unique(clinvar$Gene.s.))
genes_unicos <- sort(unique(clinvar$Gene.s.))

head(genes_unicos, 30)

genes_mmr <- c("MLH1", "MSH2", "MSH6", "PMS2", "EPCAM")

sapply(
  genes_mmr,
  function(gene) sum(grepl(gene, clinvar$Gene.s.))
)