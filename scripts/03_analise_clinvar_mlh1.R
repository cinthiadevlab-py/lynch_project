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

head(
  sort(
    table(clinvar$Name),
    decreasing = TRUE
  ),
  20
)

length(unique(clinvar$Name))

head(clinvar$Name, 20)
sum(
  grepl(
    "NM_000249.3\\(MLH1\\):c",
    clinvar$Name
  )
)

head(
  sort(
    table(clinvar$Name),
    decreasing = TRUE
  ),
  20
)

head(clinvar$Condition.s., 20) 

head(
  sort(
    table(clinvar$Condition.s.),
    decreasing = TRUE
  ),
  20
)

sum(grepl("del", clinvar$Name))
sum(grepl("dup", clinvar$Name))
sum(grepl("ins", clinvar$Name))
sum(grepl("inv", clinvar$Name))
sum(grepl("EX", clinvar$Name))

head(
  sort(
    table(clinvar$Name),
    decreasing = TRUE
  ),
  20
)

condicoes_top <- sort(
  table(clinvar$Condition.s.),
  decreasing = TRUE
)

View(as.data.frame(condicoes_top))

top_condicoes <- head(
  sort(
    table(clinvar$Condition.s.),
    decreasing = TRUE
  ),
  10
)

barplot(
  top_condicoes,
  las = 2,
  cex.names = 0.7,
  main = "Top 10 condições associadas ao MLH1",
  ylab = "Número de registros"
)

tipos_variantes <- c(
  Delecao = sum(grepl("del", clinvar$Name)),
  Duplicacao = sum(grepl("dup", clinvar$Name)),
  Insercao = sum(grepl("ins", clinvar$Name))
)

bp <- barplot(
  tipos_variantes,
  main = "Tipos de variantes estruturais em MLH1",
  ylab = "Número de registros"
)

text(
  x = bp,
  y = tipos_variantes,
  labels = tipos_variantes,
  pos = 3
)

names(clinvar)

sort(
  table(clinvar$Germline.classification),
  decreasing = TRUE
)

classificacao <- sort(
  table(clinvar$Germline.classification),
  decreasing = TRUE
)

classificacao

bp2 <- barplot(
  classificacao,
  main = "Classificação clínica das variantes MLH1",
  ylab = "Número de registros"
)

text(
  x = bp2,
  y = classificacao,
  labels = classificacao,
  pos = 3
)

sort(
  table(clinvar$Germline.review.status),
  decreasing = TRUE
)

review_status <- sort(
  table(clinvar$Germline.review.status),
  decreasing = TRUE
)
bp3 <- barplot(
  review_status,
  las = 2,
  cex.names = 0.7,
  main = "Nível de evidência clínica das variantes MLH1",
  ylab = "Número de registros"
)

text(
  x = bp3,
  y = review_status,
  labels = review_status,
  pos = 3
)
clinvar$Molecular.consequence

consequencias <- unlist(
  strsplit(
    clinvar$Molecular.consequence,
    "\\|"
  )
)

sort(
  table(consequencias),
  decreasing = TRUE
)

top_consequencias <- head(
  sort(
    table(consequencias),
    decreasing = TRUE
  ),
  10
)

bp4 <- barplot(
  top_consequencias,
  las = 2,
  cex.names = 0.7,
  ylim = c(0, max(top_consequencias) * 1.15),
  main = "Top 10 consequências moleculares em MLH1",
  ylab = "Número de registros"
)

text(
  x = bp4,
  y = top_consequencias,
  labels = top_consequencias,
  pos = 3
)

round(
  prop.table(classificacao) * 100,
  2
)