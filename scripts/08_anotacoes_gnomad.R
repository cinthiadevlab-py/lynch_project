# ==================================================
# PROJETO LYNCH - SINDROME DE LYNCH
# Script 07 - Anotacoes gnomAD
# ==================================================
#
# OBJETIVO:
# Adicionar frequencias alelicas (AF) do gnomAD
# Aplicar filtros ACMG/AMP BA1/BS1
# Validar raridade das variantes
#
# ENTRADA:
# - clinvar_mlh1_expandido.rds (resultado Script 06)
#
# SAIDA:
# - Dataframe com anotacoes gnomAD
# - Classificacoes por frequencia populacional
# - Relatorio de raridade em CSV
# ==================================================

# ==================================================
# 1. CARREGAMENTO E VALIDACAO INICIAL
# ==================================================

cat("\n=== INICIANDO SCRIPT 07 ===\n")
cat("Anotacoes gnomAD para Lynch Syndrome\n")
cat("Data:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n\n")

# Limpar ambiente
rm(list = ls())
gc()

# Validar arquivo de entrada
if (!file.exists("dados_processados/clinvar_mlh1_expandido.rds")) {
  stop("[ERRO] Execute Script 06 primeiro!")
}

cat("Carregando dados da ETAPA 6...\n")

# Definir diretorio de dados
DIR_DADOS <- "./dados_processados"

# Construir caminho do arquivo
arquivo_entrada <- file.path(DIR_DADOS, "clinvar_mlh1_expandido.rds")

# Carregar arquivo RDS
# readRDS() carrega arquivo em formato comprimido do R
# Mantém tipos exatos de dados (numeric, character, factor, etc)
df_variantes <- readRDS(arquivo_entrada)

cat("[OK] Dados carregados com sucesso!\n")
cat(sprintf("   Dimensoes: %d linhas x %d colunas\n", 
            nrow(df_variantes), ncol(df_variantes)))

# ==================================================
# 2. EXPLORACAO INICIAL DOS DADOS
# ==================================================

cat("\n=== EXPLORACAO INICIAL ===\n")

# Verificar primeiras variantes
cat("\nPrimeiras 3 variantes:\n")
print(head(df_variantes, 3))

# Listar todas as colunas disponíveis
cat("\nColunas disponíveis:\n")
print(names(df_variantes))

# ==================================================
# 3. CONTEXTO CLINICO - POR QUE gnomAD?
# ==================================================

cat("\n=== CONTEXTO CLINICO ===\n")

cat("\ngnomAD = Genome Aggregation Database\n")
cat("   - Maior banco de frequencias populacionais\n")
cat("   - 141.456 genomas + 470.315 exomas\n")
cat("   - Permite filtrar variantes por raridade\n\n")

cat("Para Lynch Syndrome (genes MLH1, MSH2, etc):\n\n")

cat("ACMG/AMP 2015 criterio BA1:\n")
cat("   AF > 5% na populacao = praticamente BENIGN\n\n")

cat("ACMG/AMP 2015 criterio BS1:\n")
cat("   AF > 1% em heterozigoto saudavel = evidencia BENIGN\n\n")

cat("REGRA PRATICA PARA LYNCH:\n")
cat("   AF < 0.01% (rara)      = possivel patogenica\n")
cat("   AF 0.01% a 1%          = moderadamente rara\n")
cat("   AF > 1%                = praticamente descartada\n\n")

cat("Lynch e doenca rara hereditaria\n")
cat("Logo: variantes causadoras DEVEM SER RARAS na populacao geral\n")

# ==================================================
# 4. VALIDACOES PRE-ANOTACAO
# ==================================================

cat("\n=== VALIDACOES PRE-ANOTACAO ===\n")

# Validacao 1: Duplicatas
n_duplicatas <- sum(duplicated(df_variantes$Name))
cat(sprintf("Duplicatas encontradas: %d\n", n_duplicatas))

if (n_duplicatas > 0) {
  cat("   Removendo duplicatas...\n")
  df_variantes <- df_variantes[!duplicated(df_variantes$Name), ]
  cat(sprintf("   Novo total: %d variantes\n", nrow(df_variantes)))
}

# Validacao 2: Colunas criticas
cat("\nVerificando colunas criticas:\n")

colunas_criticas <- c("Name", "Gene_individual", "Molecular.consequence")
colunas_existentes <- colunas_criticas %in% names(df_variantes)

for (i in 1:length(colunas_criticas)) {
  status <- if (colunas_existentes[i]) "[OK]" else "[FALTA]"
  cat(sprintf("   %s %s\n", status, colunas_criticas[i]))
}

# Validacao 3: Tipos de dados
cat("\nTipos de dados das colunas principais:\n")
print(sapply(df_variantes[, colunas_criticas], class))

cat("\n[OK] Validacoes concluidas!\n")

# ==================================================
# 5. DEFINICAO DE CRITERIOS gnomAD
# ==================================================

cat("\n=== DEFINICAO DE CRITERIOS gnomAD ===\n")

# Definir limiares de frequencia alélica (AF)
# Baseado em diretrizes ACMG/AMP 2015

LIMIAR_RARA <- 0.0001         # 0.01% - variante RARA
LIMIAR_MODERADA <- 0.01       # 1% - variante MODERADA
LIMIAR_COMUM <- 0.05          # 5% - variante COMUM/BENIGNA

cat("Limiares de frequencia definidos:\n")
cat(sprintf("   Rara:       AF < %.4f (< 0.01%%)\n", LIMIAR_RARA))
cat(sprintf("   Moderada:   AF 0.01%% a 1%%\n"))
cat(sprintf("   Comum:      AF > 1%%\n"))

cat("\nCriterios ACMG/AMP associados:\n")
cat("   BA1 (Benign):         AF > 5% OR > 1% em HET saudavel\n")
cat("   BS1 (Benign Strong):  AF > 1%\n")
cat("   PM2 (Pathogenic Mod): AF < 0.01%\n")

# ==================================================
# 6. PREPARACAO DA ESTRUTURA DE ANOTACOES
# ==================================================

cat("\n=== PREPARACAO DA ESTRUTURA ===\n")

# Criar dataframe para armazenar anotacoes gnomAD
df_anotacoes <- data.frame(
  variant_id = df_variantes$Name,
  gene = df_variantes$Gene_individual,
  consequencia = df_variantes$Molecular.consequence,
  
  # Classificacao original ClinVar (necessaria para PASSO 5)
  germline_classification_original = df_variantes$Germline.classification,
  
  # Colunas para gnomAD AF (inicialmente vazio)
  gnomad_af = NA_real_,
  gnomad_ac = NA_integer_,        # Allele Count
  gnomad_an = NA_integer_,        # Allele Number
  gnomad_homozygotes = NA_integer_,
  
  # Classificacao por frequencia
  af_categoria = NA_character_,
  af_criterio_acmg = NA_character_,
  
  # Metadata
  anotacao_status = "pendente",
  anotacao_timestamp = NA_character_,
  
  stringsAsFactors = FALSE
)

cat(sprintf("Estrutura criada: %d linhas x %d colunas\n", 
            nrow(df_anotacoes), ncol(df_anotacoes)))

cat("Colunas criadas:\n")
print(names(df_anotacoes))

cat("\n[OK] Estrutura de anotacoes pronta!\n")

# ==================================================
# 7. RESUMO DO PASSO 1
# ==================================================

cat("\n=== RESUMO DO PASSO 1 ===\n")

cat("\nDados carregados:\n")
cat(sprintf("   Total de variantes: %d\n", nrow(df_variantes)))
cat(sprintf("   Genes unicos: %d\n", length(unique(df_variantes$Gene_individual))))

cat("\nEstrutura criada:\n")
cat(sprintf("   Linhas: %d\n", nrow(df_anotacoes)))
cat(sprintf("   Colunas: %d\n", ncol(df_anotacoes))) 

# ==================================================
# PASSO 2: CARREGAR FREQUENCIAS gnomAD LOCAIS
# ==================================================

cat("\n=== PASSO 2: ANOTACOES gnomAD ===\n")
cat("Fonte: gnomAD v4.0 (Karczewski et al., 2020)\n")
cat("Arquivo: dados_brutos/gnomad_mlh1_frequencies_v4.0.tsv\n")
cat("Data acesso: 2026-06-21\n\n")

# Verificar arquivo existe
arquivo_gnomad <- "dados_brutos/gnomad_mlh1_frequencies_v4.0.tsv"
if (!file.exists(arquivo_gnomad)) {
  stop(sprintf("[ERRO] Arquivo gnomAD nao encontrado: %s", arquivo_gnomad))
}

cat("Carregando frequencias gnomAD...\n")

# Carregar arquivo com frequencias
df_gnomad <- read.table(
  arquivo_gnomad,
  header = TRUE,
  sep = "\t",
  stringsAsFactors = FALSE,
  comment.char = "#"
)

cat(sprintf("[OK] %d registros gnomAD carregados\n", nrow(df_gnomad)))

# VALIDACAO 1: Consistencia de frequencias (0 <= AF <= 1)
af_invalidos <- sum(df_gnomad$AF < 0 | df_gnomad$AF > 1, na.rm = TRUE)
if (af_invalidos > 0) {
  warning(sprintf("ATENCAO: %d frequencias invalidas encontradas", af_invalidos))
}

cat("[OK] Validacoes de consistencia concluidas\n")

# ==================================================
# PASSO 3: MESCLAR DADOS (JOIN)
# ==================================================

cat("\n=== PASSO 3: MESCLAR DADOS ===\n")
cat("Conectando frequencias gnomAD com variantes...\n\n")

# Verificar se variant_ids sao consistentes entre os dataframes
cat("Verificando consistencia das chaves (variant_id)...\n")

variantes_em_df_anotacoes <- df_anotacoes$variant_id
variantes_em_df_gnomad <- df_gnomad$variant_id

# Quantas variantes estao em ambos?
variantes_em_ambos <- sum(variantes_em_df_anotacoes %in% variantes_em_df_gnomad)

cat(sprintf("   Variantes em df_anotacoes: %d\n", length(variantes_em_df_anotacoes)))
cat(sprintf("   Variantes em df_gnomad: %d\n", length(variantes_em_df_gnomad)))
cat(sprintf("   Variantes em AMBOS: %d\n\n", variantes_em_ambos))

# Identificar variantes faltando
variantes_faltando <- sum(!variantes_em_df_anotacoes %in% variantes_em_df_gnomad)
if (variantes_faltando > 0) {
  cat(sprintf("ATENCAO: %d variantes em df_anotacoes NAO estao em df_gnomad\n\n", 
              variantes_faltando))
}

# ==================================================
# MESCLAR: usar merge() do R base
# ==================================================

cat("Executando MERGE por variant_id...\n")

# Merge: juntar por variant_id (chave comum)
df_anotacoes_com_gnomad <- merge(
  x = df_anotacoes,           # dataframe esquerda (variantes)
  y = df_gnomad,              # dataframe direita (frequencias)
  by = "variant_id",          # coluna para juntar
  all.x = TRUE,               # manter TODAS as variantes de df_anotacoes
  sort = FALSE                # nao reordenar
)

cat(sprintf("[OK] MERGE executado com sucesso!\n\n"))

# ==================================================
# VALIDACOES POS-MERGE
# ==================================================

cat("=== VALIDACOES POS-MERGE ===\n\n")

# Validacao 1: Tamanho
cat(sprintf("Tamanho de df_anotacoes: %d linhas x %d colunas\n", 
            nrow(df_anotacoes), ncol(df_anotacoes)))
cat(sprintf("Tamanho de df_anotacoes_com_gnomad: %d linhas x %d colunas\n", 
            nrow(df_anotacoes_com_gnomad), ncol(df_anotacoes_com_gnomad)))

linhas_perdidas <- nrow(df_anotacoes) - nrow(df_anotacoes_com_gnomad)
if (linhas_perdidas > 0) {
  warning(sprintf("ATENCAO: %d linhas foram perdidas no MERGE!", linhas_perdidas))
} else {
  cat("[OK] Nenhuma linha foi perdida\n")
}

# Validacao 2: Colunas
cat(sprintf("\nColunas criadas no merge:\n"))
colunas_novas <- setdiff(names(df_anotacoes_com_gnomad), names(df_anotacoes))
print(colunas_novas)

# Validacao 3: Dados gnomAD preenchidos
af_preenchidas <- sum(!is.na(df_anotacoes_com_gnomad$AF))
cat(sprintf("\nVariantes com AF preenchida: %d\n", af_preenchidas))
cat(sprintf("Variantes com AF = NA: %d\n", sum(is.na(df_anotacoes_com_gnomad$AF))))

# Validacao 4: Primeiras linhas com dados
cat("\nPrimeiras 5 variantes com dados gnomAD:\n")
print(head(df_anotacoes_com_gnomad[, c("variant_id", "gene", "AF", "AC", "AN")], 5))

cat("\n[OK] PASSO 3 VALIDACOES CONCLUIDAS!\n\n") 

# ==================================================
# PASSO 4: APLICAR FILTROS ACMG/AMP (BA1, BS1, PM2)
# ==================================================

cat("\n=== PASSO 4: APLICAR FILTROS ACMG/AMP ===\n")
cat("Classificar variantes por frequencia alélica\n\n")

# ==================================================
# DEFINIR LIMIARES (já temos do PASSO 2, mas repetir por clareza)
# ==================================================

LIMIAR_RARA <- 0.0001         # 0.01%
LIMIAR_MODERADA <- 0.01       # 1%
LIMIAR_COMUM <- 0.05          # 5%

cat("Limiares ACMG/AMP definidos:\n")
cat(sprintf("   PM2 (Pathogenic):   AF < %.4f (< 0.01%%)\n", LIMIAR_RARA))
cat(sprintf("   BS1 (Benign Strong): AF > %.2f (> 1%%)\n", LIMIAR_MODERADA))
cat(sprintf("   BA1 (Benign):       AF > %.2f (> 5%%)\n\n", LIMIAR_COMUM))

# ==================================================
# APLICAR CATEGORIZAÇÃO DE FREQUENCIA
# ==================================================

cat("Categorizando frequencias alelicas...\n")

# Criar coluna af_categoria (descrição textual)
df_anotacoes_com_gnomad$af_categoria <- NA_character_

# Aplicar lógica (com ordem INVERSA - do mais raro para mais comum)
df_anotacoes_com_gnomad$af_categoria[
  df_anotacoes_com_gnomad$AF < LIMIAR_RARA
] <- "Muito rara (< 0.01%)"

df_anotacoes_com_gnomad$af_categoria[
  df_anotacoes_com_gnomad$AF >= LIMIAR_RARA & 
    df_anotacoes_com_gnomad$AF < LIMIAR_MODERADA
] <- "Rara (0.01% - 1%)"

df_anotacoes_com_gnomad$af_categoria[
  df_anotacoes_com_gnomad$AF >= LIMIAR_MODERADA & 
    df_anotacoes_com_gnomad$AF < LIMIAR_COMUM
] <- "Moderadamente comum (1% - 5%)"

df_anotacoes_com_gnomad$af_categoria[
  df_anotacoes_com_gnomad$AF >= LIMIAR_COMUM
] <- "Muito comum (> 5%)"

# Dados faltando (NA)
df_anotacoes_com_gnomad$af_categoria[
  is.na(df_anotacoes_com_gnomad$AF)
] <- "Dados faltando (NA)"

cat("[OK] Categorias criadas!\n\n")

# ==================================================
# APLICAR CRITERIOS ACMG/AMP
# ==================================================

cat("Aplicando criterios ACMG/AMP...\n")

# Criar coluna af_criterio_acmg
df_anotacoes_com_gnomad$af_criterio_acmg <- NA_character_

# PM2: AF < 0.01% (evidência de patogenicidade)
df_anotacoes_com_gnomad$af_criterio_acmg[
  df_anotacoes_com_gnomad$AF < LIMIAR_RARA
] <- "PM2"

# BS1: AF > 1% (evidência de benignidade)
df_anotacoes_com_gnomad$af_criterio_acmg[
  df_anotacoes_com_gnomad$AF >= LIMIAR_MODERADA & 
    df_anotacoes_com_gnomad$AF < LIMIAR_COMUM
] <- "BS1"

# BA1: AF > 5% (evidência FORTE de benignidade)
df_anotacoes_com_gnomad$af_criterio_acmg[
  df_anotacoes_com_gnomad$AF >= LIMIAR_COMUM
] <- "BA1"

# Intermediárias (0.01% - 1%) - sem critério direto de AF
df_anotacoes_com_gnomad$af_criterio_acmg[
  df_anotacoes_com_gnomad$AF >= LIMIAR_RARA & 
    df_anotacoes_com_gnomad$AF < LIMIAR_MODERADA
] <- "Intermediária (sem AF direto)"

# Dados faltando
df_anotacoes_com_gnomad$af_criterio_acmg[
  is.na(df_anotacoes_com_gnomad$AF)
] <- "NA (dados faltando)"

cat("[OK] Criterios ACMG/AMP aplicados!\n\n")

# ==================================================
# VALIDACOES POS-CLASSIFICACAO
# ==================================================

cat("=== VALIDACOES POS-CLASSIFICACAO ===\n\n")

# Validacao 1: Distribuição de categorias
cat("Distribuição por categoria de frequencia:\n")
tabela_categorias <- table(df_anotacoes_com_gnomad$af_categoria)
print(tabela_categorias)

cat("\nProporção:\n")
prop_categorias <- prop.table(tabela_categorias) * 100
for (categoria in names(prop_categorias)) {
  cat(sprintf("   %s: %.1f%%\n", categoria, prop_categorias[categoria]))
}

# Validacao 2: Distribuição de critérios ACMG
cat("\nDistribuição por criterio ACMG/AMP:\n")
tabela_criterios <- table(df_anotacoes_com_gnomad$af_criterio_acmg)
print(tabela_criterios)

cat("\nProporção:\n")
prop_criterios <- prop.table(tabela_criterios) * 100
for (criterio in names(prop_criterios)) {
  cat(sprintf("   %s: %.1f%%\n", criterio, prop_criterios[criterio]))
}

# Validacao 3: Variantes BA1 (praticamente benignas)
ba1_count <- sum(df_anotacoes_com_gnomad$af_criterio_acmg == "BA1", na.rm = TRUE)
cat(sprintf("\nVariantes BA1 (AF > 5%% - BENIGNAS): %d (%.1f%%)\n", 
            ba1_count, ba1_count / nrow(df_anotacoes_com_gnomad) * 100))

# Validacao 4: Variantes BS1 (evidência benign strong)
bs1_count <- sum(df_anotacoes_com_gnomad$af_criterio_acmg == "BS1", na.rm = TRUE)
cat(sprintf("Variantes BS1 (AF > 1%% - BENIGN STRONG): %d (%.1f%%)\n", 
            bs1_count, bs1_count / nrow(df_anotacoes_com_gnomad) * 100))

# Validacao 5: Variantes PM2 (evidência pathogenic moderate)
pm2_count <- sum(df_anotacoes_com_gnomad$af_criterio_acmg == "PM2", na.rm = TRUE)
cat(sprintf("Variantes PM2 (AF < 0.01%% - PATHOGENIC MOD): %d (%.1f%%)\n", 
            pm2_count, pm2_count / nrow(df_anotacoes_com_gnomad) * 100))

# Validacao 6: Exemplos de cada categoria
cat("\n=== EXEMPLOS DE CADA CATEGORIA ===\n\n")

categorias_unicas <- unique(na.omit(df_anotacoes_com_gnomad$af_categoria))

for (cat in categorias_unicas) {
  cat(sprintf("\n>>> %s\n", cat))
  
  # Pegar 2 exemplos dessa categoria
  exemplos <- df_anotacoes_com_gnomad[
    df_anotacoes_com_gnomad$af_categoria == cat, 
    c("variant_id", "gene", "AF", "af_categoria", "af_criterio_acmg")
  ]
  
  if (nrow(exemplos) > 0) {
    print(head(exemplos, 2))
  }
}

cat("\n[OK] PASSO 4 CONCLUIDO!\n\n") 

# ==================================================
# PASSO 5: GERAR CLASSIFICACOES DE PATOGENICIDADE (CORRIGIDO)
# ==================================================

cat("\n=== PASSO 5: GERAR CLASSIFICACOES ===\n")
cat("Combinar evidencias e classificar variantes\n\n")

# ==================================================
# CRIAR COLUNA DE CLASSIFICACAO FINAL
# ==================================================

cat("Gerando classificacao final...\n")

# Inicializar coluna
df_anotacoes_com_gnomad$classificacao_final <- NA_character_

# ==================================================
# REGRA 1: BA1 (AF > 5%) = BENIGN
# ==================================================

df_anotacoes_com_gnomad$classificacao_final[
  df_anotacoes_com_gnomad$af_criterio_acmg == "BA1"
] <- "Benign (BA1)"

cat("[OK] Regra BA1 aplicada\n")

# ==================================================
# REGRA 2: BS1 (AF > 1%) = LIKELY BENIGN
# ==================================================

df_anotacoes_com_gnomad$classificacao_final[
  df_anotacoes_com_gnomad$af_criterio_acmg == "BS1"
] <- "Likely Benign (BS1)"

cat("[OK] Regra BS1 aplicada\n")

# ==================================================
# REGRA 3: PM2 (AF < 0.01%) = evidencia de PATHOGENIC
# Combinar com classificacao original ClinVar
# ==================================================

# PM2 + Pathogenic original = Pathogenic
df_anotacoes_com_gnomad$classificacao_final[
  df_anotacoes_com_gnomad$af_criterio_acmg == "PM2" &
    (df_anotacoes_com_gnomad$germline_classification_original == "Pathogenic" |
       df_anotacoes_com_gnomad$germline_classification_original == "Pathogenic/Likely pathogenic")
] <- "Pathogenic (PM2+)"

cat("[OK] Regra PM2+Pathogenic aplicada\n")

# ==================================================
# REGRA 4: Intermediária (0.01% - 1%) = VUS
# ==================================================

df_anotacoes_com_gnomad$classificacao_final[
  df_anotacoes_com_gnomad$af_criterio_acmg == "Intermediária (sem AF direto)" &
    is.na(df_anotacoes_com_gnomad$classificacao_final)
] <- "VUS (AF intermediária)"

cat("[OK] Regra Intermediária aplicada\n")

# ==================================================
# REGRA 5: NA (dados faltando) = suporta patogenicidade
# ==================================================

df_anotacoes_com_gnomad$classificacao_final[
  df_anotacoes_com_gnomad$af_criterio_acmg == "NA (dados faltando)" &
    (df_anotacoes_com_gnomad$germline_classification_original == "Pathogenic" |
       df_anotacoes_com_gnomad$germline_classification_original == "Pathogenic/Likely pathogenic") &
    is.na(df_anotacoes_com_gnomad$classificacao_final)
] <- "Likely Pathogenic (NA+P)"

cat("[OK] Regra NA (dados faltando) aplicada\n\n")

# ==================================================
# VALIDACOES POS-CLASSIFICACAO
# ==================================================

cat("=== VALIDACOES POS-CLASSIFICACAO ===\n\n")

# Validacao 1: Quantas variantes foram classificadas?
classificadas <- sum(!is.na(df_anotacoes_com_gnomad$classificacao_final))
nao_classificadas <- sum(is.na(df_anotacoes_com_gnomad$classificacao_final))

cat(sprintf("Variantes classificadas: %d (%.1f%%)\n", 
            classificadas, classificadas / nrow(df_anotacoes_com_gnomad) * 100))
cat(sprintf("Variantes NAO classificadas: %d (%.1f%%)\n\n", 
            nao_classificadas, nao_classificadas / nrow(df_anotacoes_com_gnomad) * 100))

# Validacao 2: Distribuição de classificações
cat("Distribuição de classificacoes finais:\n")
tabela_final <- table(df_anotacoes_com_gnomad$classificacao_final)
print(tabela_final)

cat("\nProporção:\n")
prop_final <- prop.table(tabela_final) * 100
for (classif in names(prop_final)) {
  cat(sprintf("   %s: %.1f%%\n", classif, prop_final[classif]))
}

# Validacao 3: Resumo simplificado (categorias principais)
cat("\n=== RESUMO DAS CLASSIFICACOES ===\n\n")

pathogenic_count <- sum(grepl("Pathogenic", df_anotacoes_com_gnomad$classificacao_final))
vus_count <- sum(grepl("VUS", df_anotacoes_com_gnomad$classificacao_final))
benign_count <- sum(grepl("Benign", df_anotacoes_com_gnomad$classificacao_final))

cat(sprintf("Pathogenic / Likely Pathogenic: %4d (%.1f%%)\n", 
            pathogenic_count, pathogenic_count / nrow(df_anotacoes_com_gnomad) * 100))
cat(sprintf("VUS (Uncertain):                %4d (%.1f%%)\n", 
            vus_count, vus_count / nrow(df_anotacoes_com_gnomad) * 100))
cat(sprintf("Benign / Likely Benign:         %4d (%.1f%%)\n\n", 
            benign_count, benign_count / nrow(df_anotacoes_com_gnomad) * 100))

# Validacao 4: Exemplos de cada categoria
cat("=== EXEMPLOS DE CADA CATEGORIA ===\n\n")

categorias_finais <- unique(na.omit(df_anotacoes_com_gnomad$classificacao_final))

for (cat_final in sort(categorias_finais)) {
  cat(sprintf("\n>>> %s\n", cat_final))
  
  exemplos <- df_anotacoes_com_gnomad[
    df_anotacoes_com_gnomad$classificacao_final == cat_final, 
    c("variant_id", "gene", "AF", "af_criterio_acmg", "germline_classification_original", "classificacao_final")
  ]
  
  if (nrow(exemplos) > 0) {
    print(head(exemplos, 2))
  }
}

cat("\n[OK] PASSO 5 CONCLUIDO!\n\n") 

# ==================================================
# PASSO 6: EXPORTAR RESULTADOS
# ==================================================

cat("\n=== PASSO 6: EXPORTAR RESULTADOS ===\n")
cat("Salvar anotacoes em CSV e RDS\n\n")

# ==================================================
# CRIAR DIRETORIOS SE NAO EXISTIREM
# ==================================================

cat("Verificando diretorios de saida...\n")

# Diretório para CSV
dir_results <- "./results"
if (!dir.exists(dir_results)) {
  dir.create(dir_results, showWarnings = FALSE)
  cat(sprintf("[OK] Diretorio criado: %s\n", dir_results))
} else {
  cat(sprintf("[OK] Diretorio ja existe: %s\n", dir_results))
}

# Diretório para RDS
dir_dados_proc <- "./dados_processados"
if (!dir.exists(dir_dados_proc)) {
  dir.create(dir_dados_proc, showWarnings = FALSE)
  cat(sprintf("[OK] Diretorio criado: %s\n", dir_dados_proc))
} else {
  cat(sprintf("[OK] Diretorio ja existe: %s\n", dir_dados_proc))
}

# ==================================================
# VALIDACAO PRE-EXPORTACAO
# ==================================================

cat("\n=== VALIDACAO PRE-EXPORTACAO ===\n\n")

# Validacao 1: Linhas
linhas_antes <- nrow(df_anotacoes_com_gnomad)
cat(sprintf("Variantes para exportar: %d\n", linhas_antes))

# Validacao 2: Colunas
colunas_antes <- ncol(df_anotacoes_com_gnomad)
cat(sprintf("Colunas para exportar: %d\n", colunas_antes))

# Validacao 3: Nao classificadas
nao_classif <- sum(is.na(df_anotacoes_com_gnomad$classificacao_final))
cat(sprintf("Variantes nao classificadas: %d\n", nao_classif))

if (nao_classif > 0) {
  warning(sprintf("ATENCAO: %d variantes sem classificacao final!", nao_classif))
} else {
  cat("[OK] Todas as variantes foram classificadas!\n")
}

# Validacao 4: Existem dados gnomAD?
af_preenchidas <- sum(!is.na(df_anotacoes_com_gnomad$AF))
cat(sprintf("Variantes com AF preenchida: %d\n", af_preenchidas))

# Validacao 5: Existem classificações ClinVar?
clinvar_preenchidas <- sum(!is.na(df_anotacoes_com_gnomad$germline_classification_original))
cat(sprintf("Variantes com classificacao ClinVar: %d\n\n", clinvar_preenchidas))

# ==================================================
# EXPORTAR CSV
# ==================================================

cat("=== EXPORTANDO CSV ===\n")

arquivo_csv <- file.path(dir_results, "08_anotacoes_gnomad_completo.csv")

# Reordenar colunas para melhor legibilidade
colunas_ordem <- c(
  "variant_id",
  "gene",
  "consequencia",
  "germline_classification_original",
  "AF",
  "AC",
  "AN",
  "af_categoria",
  "af_criterio_acmg",
  "classificacao_final",
  "anotacao_status",
  "anotacao_timestamp"
)

# Selecionar colunas na ordem definida
df_export_csv <- df_anotacoes_com_gnomad[, colunas_ordem]

# Exportar CSV
write.csv(
  df_export_csv,
  file = arquivo_csv,
  row.names = FALSE,
  quote = TRUE,
  na = ""
)

cat(sprintf("[OK] Arquivo CSV exportado: %s\n", arquivo_csv))

# Validacao do CSV
tamanho_csv <- file.size(arquivo_csv)
cat(sprintf("    Tamanho: %.2f KB\n", tamanho_csv / 1024))

linhas_csv <- nrow(read.csv(arquivo_csv))
cat(sprintf("    Linhas: %d\n\n", linhas_csv))

# ==================================================
# EXPORTAR RDS
# ==================================================

cat("=== EXPORTANDO RDS ===\n")

arquivo_rds <- file.path(dir_dados_proc, "clinvar_mlh1_com_gnomad.rds")

# Exportar RDS (mantém tipos exatos, comprimido)
saveRDS(
  df_anotacoes_com_gnomad,
  file = arquivo_rds,
  compress = "gzip"
)

cat(sprintf("[OK] Arquivo RDS exportado: %s\n", arquivo_rds))

# Validacao do RDS
tamanho_rds <- file.size(arquivo_rds)
cat(sprintf("    Tamanho: %.2f KB\n", tamanho_rds / 1024))

# Tentar carregar para verificar integridade
df_test <- readRDS(arquivo_rds)
linhas_rds <- nrow(df_test)
colunas_rds <- ncol(df_test)
cat(sprintf("    Linhas: %d | Colunas: %d\n\n", linhas_rds, colunas_rds))

# ==================================================
# RESUMO FINAL
# ==================================================

cat("=== RESUMO FINAL DE EXPORTACAO ===\n\n")

cat("Arquivos salvos com sucesso:\n\n")

cat(sprintf("1. CSV: %s\n", arquivo_csv))
cat(sprintf("   - Variantes: %d\n", linhas_csv))
cat(sprintf("   - Colunas: %d\n", ncol(df_export_csv)))
cat(sprintf("   - Tamanho: %.2f KB\n\n", tamanho_csv / 1024))

cat(sprintf("2. RDS: %s\n", arquivo_rds))
cat(sprintf("   - Variantes: %d\n", linhas_rds))
cat(sprintf("   - Colunas: %d\n", colunas_rds))
cat(sprintf("   - Tamanho: %.2f KB\n\n", tamanho_rds / 1024))

# ==================================================
# INFORMACOES PARA PROXIMO SCRIPT
# ==================================================

cat("=== INFORMACOES PARA PROXIMO SCRIPT ===\n\n")

cat("Para usar esses dados em proximos scripts:\n\n")

cat("Carregar CSV:\n")
cat(sprintf("  df <- read.csv('%s')\n\n", arquivo_csv))

cat("Carregar RDS (recomendado):\n")
cat(sprintf("  df <- readRDS('%s')\n\n", arquivo_rds))

cat("Verificar estrutura:\n")
cat("  str(df)\n")
cat("  head(df)\n\n")

# ==================================================
# VALIDACAO FINAL
# ==================================================

cat("=== VALIDACAO FINAL ===\n\n")

# Ambos arquivos existem?
csv_existe <- file.exists(arquivo_csv)
rds_existe <- file.exists(arquivo_rds)

cat(sprintf("Arquivo CSV existe: %s\n", if(csv_existe) "SIM" else "NAO"))
cat(sprintf("Arquivo RDS existe: %s\n\n", if(rds_existe) "SIM" else "NAO"))

if (csv_existe && rds_existe) {
  cat("[OK] PASSO 6 CONCLUIDO COM SUCESSO!\n")
  cat("[OK] SCRIPT 08 COMPLETAMENTE FINALIZADO!\n\n")
} else {
  stop("[ERRO] Algum arquivo nao foi salvo corretamente!")
}

cat("Proxima etapa: Script 09 (Analise de genes e impacto)\n\n")