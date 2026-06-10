# ==========================================
# PARTE 5 — ANÁLISES RELACIONAIS
# Projeto Síndrome de Lynch
# ==========================================

source("scripts/02_importacao_dados.R") 
clinvar <- clinvar_mlh1
tabela_condicao_classificacao <- table(
  clinvar$Condition.s.,
  clinvar$Germline.classification
)
# ==========================================
# VALIDAÇÕES INICIAIS
# ==========================================

dim(tabela_condicao_classificacao)

tabela_condicao_classificacao[1:10, ] 

sort(
  tabela_condicao_classificacao,
  decreasing = TRUE
)[1:20]

# ==========================================
# CONVERTER PARA DATA FRAME
# ==========================================

relacao_condicao <- as.data.frame(
  tabela_condicao_classificacao
)

head(relacao_condicao)

# ==========================================
# TOP RELAÇÕES MAIS FREQUENTES
# ==========================================

relacao_condicao <- relacao_condicao[
  order(relacao_condicao$Freq,
        decreasing = TRUE),
]

head(relacao_condicao, 20)

# Conferir se todas as observações foram preservadas

sum(relacao_condicao$Freq) 
# Resultado esperado: 1745
# Mesmo número de registros do banco original

# ==========================================
# PRINCIPAIS CONDIÇÕES CLÍNICAS
# ==========================================

top_condicoes_relacionais <- relacao_condicao[
  relacao_condicao$Freq >= 20,
]

top_condicoes_relacionais

# ==========================================
# APENAS VARIANTES PATOGÊNICAS
# ==========================================

patogenicas <- subset(
  relacao_condicao,
  Var2 == "Pathogenic"
)

head(patogenicas, 20)

# ==========================================
# VARIANTES PATHOGENIC/LIKELY PATHOGENIC
# ==========================================

patogenicas_provaveis <- subset(
  relacao_condicao,
  Var2 == "Pathogenic/Likely pathogenic"
)

head(patogenicas_provaveis, 20) 

# ==========================================
# OBSERVAÇÕES
# ==========================================

# As variantes classificadas como Pathogenic
# concentram a maioria absoluta dos registros
# do banco analisado.

# As variantes classificadas como
# Pathogenic/Likely pathogenic representam
# uma fração menor dos registros.

# ==========================================
# INTERPRETAÇÃO INICIAL
# ==========================================

# As classificações Pathogenic/Likely pathogenic
# apresentam, com relativa frequência,
# associações envolvendo múltiplas condições
# clínicas simultaneamente.

# ==========================================
# CONCLUSÃO PARCIAL
# ==========================================

# As análises indicam que as variantes de MLH1
# estão predominantemente associadas ao espectro
# clínico da Síndrome de Lynch.
#
# A maior parte dos registros encontra-se
# classificada como Pathogenic, enquanto as
# classificações Pathogenic/Likely pathogenic
# representam uma parcela menor do conjunto.

# ==========================================
# CONSEQUÊNCIA MOLECULAR × CLASSIFICAÇÃO
# ==========================================
tabela_consequencia_classificacao <- table(
  clinvar$Molecular.consequence,
  clinvar$Germline.classification
) 
# ==========================================
# VALIDAÇÃO
# ==========================================

dim(tabela_consequencia_classificacao)

tabela_consequencia_classificacao[1:10, ]

sum(clinvar$Molecular.consequence == "")

# Observação:
# Existem 193 registros sem anotação
# de consequência molecular no banco.
#
# Esses registros serão preservados
# nas análises para manter a integridade
# do conjunto de dados original.

# ==========================================
# CONVERTER PARA DATA FRAME
# ==========================================

relacao_consequencia <- as.data.frame(
  tabela_consequencia_classificacao
)

head(relacao_consequencia) 

# ==========================================
# TOP RELAÇÕES MAIS FREQUENTES
# ==========================================

relacao_consequencia <- relacao_consequencia[
  order(relacao_consequencia$Freq,
        decreasing = TRUE),
]

head(relacao_consequencia, 20) 

# ==========================================
# OBSERVAÇÕES
# ==========================================

# As consequências moleculares mais frequentes
# estão associadas principalmente a variantes
# frameshift, nonsense e alterações de splicing.

# O conjunto apresenta predominância de
# mecanismos compatíveis com perda de função
# do gene MLH1.

# ==========================================
# VALIDAÇÃO DE INTEGRIDADE
# ==========================================

sum(relacao_consequencia$Freq) 
# Resultado esperado: 1745
# Mesmo número de registros do banco original 

# ==========================================
# TOP CONSEQUÊNCIAS MOLECULARES
# ==========================================

top_consequencias <- relacao_consequencia[
  relacao_consequencia$Freq >= 15,
]
top_consequencias

# ==========================================
# INTERPRETAÇÃO BIOLÓGICA
# ==========================================

# As consequências moleculares mais frequentes
# são predominantemente variantes do tipo
# frameshift, nonsense e alterações de splicing.

# Esses mecanismos estão frequentemente
# associados à perda de função (loss of function)
# do gene MLH1, padrão compatível com a
# fisiopatologia da Síndrome de Lynch.

table(relacao_consequencia$Var2) 

# ==========================================
# VALIDAÇÃO ESTRUTURAL
# ==========================================

# Foram identificadas 70 categorias distintas
# de consequência molecular.

# Todas aparecem associadas tanto às variantes
# Pathogenic quanto às variantes
# Pathogenic/Likely pathogenic.

# A diferença entre os grupos ocorre
# principalmente na frequência observada
# de cada consequência molecular.

# ==========================================
# GENE × CLASSIFICAÇÃO CLÍNICA
# ==========================================

tabela_gene_classificacao <- table(
  clinvar$Gene.s.,
  clinvar$Germline.classification
)

# ==========================================
# VALIDAÇÃO
# ==========================================

dim(tabela_gene_classificacao)

tabela_gene_classificacao

# Observação:
# O campo Gene.s. apresenta múltiplos genes
# associados a determinadas variantes e não
# representa exclusivamente o gene causal.
#
# Como o banco já foi previamente filtrado
# para variantes relacionadas ao MLH1,
# esta análise não foi aprofundada.

names(clinvar)

# ==========================================
# TIPO DE VARIANTE × CLASSIFICAÇÃO
# ==========================================

tabela_tipo_classificacao <- table(
  clinvar$Variant.type,
  clinvar$Germline.classification
)
# ==========================================
# VALIDAÇÃO
# ==========================================

dim(tabela_tipo_classificacao)
# ==========================================
# VISUALIZAR TABELA
# ==========================================

tabela_tipo_classificacao

# ==========================================
# OBSERVAÇÕES
# ==========================================

# Deleções representam o tipo de variante
# mais frequente no conjunto analisado.

# Variantes de nucleotídeo único (SNV)
# e duplicações também aparecem com
# frequência elevada.

# A maior parte dos registros encontra-se
# classificada como Pathogenic.

# ==========================================
# INTERPRETAÇÃO BIOLÓGICA
# ==========================================

# O predomínio de deleções sugere que
# mecanismos capazes de interromper ou
# comprometer a função do gene MLH1
# representam uma importante fonte de
# variantes patogênicas associadas à
# Síndrome de Lynch.

# ==========================================
# VALIDAÇÃO DE INTEGRIDADE
# ==========================================

sum(tabela_tipo_classificacao)

# ==========================================
# CONCLUSÃO PARCIAL
# ==========================================

# As deleções representam o principal tipo
# de variante observado no conjunto de dados.

# Em conjunto com o predomínio de variantes
# frameshift, nonsense e alterações de splicing,
# os resultados reforçam a importância de
# mecanismos de perda de função do gene MLH1
# na Síndrome de Lynch.

nrow(top_condicoes_relacionais)

# ==========================================
# DADOS PARA VISUALIZAÇÃO
# ==========================================

grafico_condicoes <- top_condicoes_relacionais
grafico_condicoes

top4_condicoes <- grafico_condicoes[1:4, ]

top4_condicoes

library(ggplot2) 
# Caso o pacote não esteja instalado:
# install.packages("ggplot2")

# ==========================================
# GRÁFICO 1 — PRINCIPAIS CONDIÇÕES CLÍNICAS
# ==========================================

ggplot(
  top4_condicoes,
  aes(
    x = reorder(Var1, Freq),
    y = Freq
  )
) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Top condições clínicas associadas às variantes MLH1",
    x = "Condição clínica",
    y = "Frequência"
  ) +
  theme_minimal() 

nrow(top_consequencias)

# ==========================================
# DADOS PARA VISUALIZAÇÃO
# ==========================================

top10_consequencias <- top_consequencias[1:10, ]

top10_consequencias

# ==========================================
# REMOVER CONSEQUÊNCIAS VAZIAS
# ==========================================

top10_consequencias <- subset(
  top_consequencias,
  Var1 != ""
)

top10_consequencias <- top10_consequencias[1:10, ]

top10_consequencias

# ==========================================
# GRÁFICO 2 — CONSEQUÊNCIAS MOLECULARES
# ==========================================

ggplot(
  top10_consequencias,
  aes(
    x = reorder(Var1, Freq),
    y = Freq
  )
) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Principais consequências moleculares das variantes MLH1",
    x = "Consequência molecular",
    y = "Frequência"
  ) +
  theme_minimal()

tipo_variantes_df <- as.data.frame(
  tabela_tipo_classificacao
)

tipo_variantes_df

tipo_variantes_df <- tipo_variantes_df[
  order(
    tipo_variantes_df$Freq,
    decreasing = TRUE
  ),
]

tipo_variantes_df

top6_tipos <- subset(
  tipo_variantes_df,
  Freq >= 40
)

top6_tipos

top_tipos_total <- aggregate(
  Freq ~ Var1,
  data = tipo_variantes_df,
  sum
)

top_tipos_total

top_tipos_total <- top_tipos_total[
  order(
    top_tipos_total$Freq,
    decreasing = TRUE
  ),
]

top_tipos_total

top6_tipos_total <- top_tipos_total[1:6, ]

top6_tipos_total

# ==========================================
# GRÁFICO 3 — TIPOS DE VARIANTES
# ==========================================

ggplot(
  top6_tipos_total,
  aes(
    x = reorder(Var1, Freq),
    y = Freq
  )
) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Principais tipos de variantes observados em MLH1",
    x = "Tipo de variante",
    y = "Frequência"
  ) +
  theme_minimal()

# ==========================================
# INTERPRETAÇÃO DO GRÁFICO
# ==========================================

# As deleções representam o principal tipo
# de variante observado no conjunto de dados.

# Variantes de nucleotídeo único (SNV) e
# duplicações também apresentam frequências
# elevadas.

# O predomínio desses tipos de alterações
# reforça a importância de mecanismos capazes
# de comprometer a função normal do gene MLH1.

# ==========================================
# EXPORTAÇÃO DE RESULTADOS
# ==========================================

write.csv(
  top_condicoes_relacionais,
  "results/top_condicoes_relacionais.csv",
  row.names = FALSE
)

write.csv(
  top_consequencias,
  "results/top_consequencias.csv",
  row.names = FALSE
)

write.csv(
  top_tipos_total,
  "results/top_tipos_variantes.csv",
  row.names = FALSE
)
source("scripts/04_analises_relacionais_mlh1.R") 
