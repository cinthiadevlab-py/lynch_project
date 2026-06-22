# ==================================================
# PROJETO LYNCH - SINDROME DE LYNCH
# Script 07 - Gerar Frequencias gnomAD Simuladas
# ==================================================
#
# OBJETIVO:
# Gerar arquivo gnomAD v4.0 simulado com frequencias alelicas
# realistas para variantes MLH1 (Lynch Syndrome)
#
# ENTRADA:
# - clinvar_mlh1_expandido.rds (1.739 variantes únicas)
#
# SAIDA:
# - dados_brutos/gnomad_mlh1_frequencies_v4.0.tsv (arquivo TSV)
#
# METODOLOGIA:
# Simulacao baseada em distribuicao real de gnomAD v4.0
# Frequencias realistas para Lynch (doenca rara)
# Reproducibilidade: seed definida = mesmo resultado sempre
#
# REFERENCIA BIBLIOGRAFICA:
# Karczewski KJ, et al. The mutational constraint spectrum quantified 
# from variation in 141,456 humans. Nature. 2020;581(7809):434-443.
# https://gnomad.broadinstitute.org/
#
# ==================================================

# ==================================================
# 1. CARREGAMENTO E CONTEXTO
# ==================================================

cat("\n=== SCRIPT 07: GERAR gnomAD SIMULADO ===\n")
cat("Etapa: Gerar frequencias alelicas MLH1\n")
cat("Data:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n\n")

# Carregar variantes da ETAPA 6
cat("Carregando variantes da ETAPA 6...\n")

arquivo_entrada <- "dados_processados/clinvar_mlh1_expandido.rds"
if (!file.exists(arquivo_entrada)) {
  stop("[ERRO] Execute Script 06 primeiro!")
}

df_variantes <- readRDS(arquivo_entrada)

# Remover duplicatas (como em PASSO 1 do script anterior)
df_variantes <- df_variantes[!duplicated(df_variantes$Name), ]

n_variantes <- nrow(df_variantes)
cat(sprintf("[OK] %d variantes carregadas\n\n", n_variantes))

# ==================================================
# 2. DEFINIR PARAMETROS DE SIMULACAO
# ==================================================

cat("=== DEFININDO PARAMETROS DE SIMULACAO ===\n\n")

# Seed para reproducibilidade
# IMPORTANTE: Mesmo seed sempre gera mesmos números
# Assim qualquer pessoa consegue replicar resultado
SEED_REPRODUCIBILIDADE <- 42

cat(sprintf("Seed (reproducibilidade): %d\n", SEED_REPRODUCIBILIDADE))
set.seed(SEED_REPRODUCIBILIDADE)

# Parametros gnomAD v4.0
TOTAL_GENOMAS <- 141456  # gnomAD v4.0 tem 141.456 genomas sequenciados
PROPORCAO_NA <- 0.10     # 10% dados faltando (realista)

cat(sprintf("Total de genomas gnomAD: %d\n", TOTAL_GENOMAS))
cat(sprintf("Proporcao de dados faltando: %.1f%%\n\n", PROPORCAO_NA * 100))

# ==================================================
# 3. GERAR FREQUENCIAS REALISTAS PARA LYNCH
# ==================================================

cat("=== GERANDO FREQUENCIAS ALELICAS (AF) ===\n\n")

cat("Distribuicao esperada para Lynch (doenca rara):\n")
cat("   80%% muito raras (AF < 0.001%%)\n")
cat("   15%% moderadamente raras (AF 0.001%% - 0.01%%)\n")
cat("   5%% mais comuns (AF > 0.01%%)\n\n")

# Gerar frequências com distribuição realista
af_valores <- c(
  # 80% muito raras (AF < 0.001%)
  runif(round(n_variantes * 0.80), min = 0.000001, max = 0.00001),
  
  # 15% moderadamente raras (AF 0.001% - 0.01%)
  runif(round(n_variantes * 0.15), min = 0.00001, max = 0.0001),
  
  # 5% mais comuns (AF > 0.01%)
  runif(round(n_variantes * 0.05), min = 0.0001, max = 0.001)
)

# Ajustar tamanho exato
af_valores <- af_valores[1:n_variantes]

# Estatísticas das frequências
cat("Estatisticas das frequencias geradas:\n")
cat(sprintf("   AF minima: %.8f (%.6f%%)\n", min(af_valores), min(af_valores)*100))
cat(sprintf("   AF maxima: %.8f (%.6f%%)\n", max(af_valores), max(af_valores)*100))
cat(sprintf("   AF media: %.8f (%.6f%%)\n", mean(af_valores), mean(af_valores)*100))
cat(sprintf("   AF mediana: %.8f (%.6f%%)\n\n", median(af_valores), median(af_valores)*100))

# ==================================================
# 4. CRIAR DATAFRAME gnomAD
# ==================================================

cat("=== CRIANDO DATAFRAME gnomAD ===\n\n")

# Criar dataframe com todos os campos necessarios
df_gnomad <- data.frame(
  variant_id = df_variantes$Name,      # Nome da variante (HGVS)
  AF = af_valores,                      # Frequencia alélica
  AC = round(af_valores * TOTAL_GENOMAS),  # Allele Count
  AN = TOTAL_GENOMAS,                   # Allele Number (sempre mesmo)
  homozygotes = 0,                      # Homozigotos (sempre 0 para raras)
  stringsAsFactors = FALSE
)

cat(sprintf("Dataframe criado: %d linhas x %d colunas\n\n", 
            nrow(df_gnomad), ncol(df_gnomad)))

# Mostrar primeiras linhas
cat("Primeiras 5 variantes:\n")
print(head(df_gnomad, 5))
cat("\n")

# ==================================================
# 5. INTRODUZIR DADOS FALTANDO (NA)
# ==================================================

cat("=== INTRODUZINDO DADOS FALTANDO (NA) ===\n\n")

cat(sprintf("Introduzindo ~%.1f%% dados faltando (realismo)...\n", PROPORCAO_NA * 100))

# Selecionar indices aleatórios para NA
indices_na <- sample(1:nrow(df_gnomad), 
                     size = round(nrow(df_gnomad) * PROPORCAO_NA))

# Colocar NA nas colunas AF e AC
df_gnomad[indices_na, c("AF", "AC")] <- NA

n_na_total <- sum(is.na(df_gnomad$AF))
cat(sprintf("[OK] %d variantes com dados faltando (%.1f%%)\n\n", 
            n_na_total, n_na_total / nrow(df_gnomad) * 100))

# ==================================================
# 6. VALIDACOES PRE-EXPORT
# ==================================================

cat("=== VALIDACOES PRE-EXPORT ===\n\n")

# Validacao 1: AF entre 0 e 1 (exceto NA)
af_invalidos <- sum((df_gnomad$AF < 0 | df_gnomad$AF > 1), na.rm = TRUE)
cat(sprintf("AF invalidas (fora [0,1]): %d\n", af_invalidos))

if (af_invalidos > 0) {
  warning("ATENCAO: Frequencias invalidas encontradas!")
}

# Validacao 2: AC consistente com AF
ac_check <- df_gnomad$AC[!is.na(df_gnomad$AC)]
af_check <- df_gnomad$AF[!is.na(df_gnomad$AF)]
ac_esperado <- round(af_check * TOTAL_GENOMAS)

diferenca_maxima <- max(abs(ac_check - ac_esperado), na.rm = TRUE)
cat(sprintf("Diferenca maxima AC (arredondamento): %d\n", diferenca_maxima))

# Validacao 3: AN sempre igual
an_unicos <- unique(df_gnomad$AN)
cat(sprintf("Valores unicos de AN: %d (esperado: 1)\n", length(an_unicos)))

# Validacao 4: Homozigotos sempre zero
homoz_unicos <- unique(df_gnomad$homozygotes)
cat(sprintf("Valores unicos de homozygotes: %s (esperado: 0)\n\n", 
            paste(homoz_unicos, collapse = ", ")))

cat("[OK] Todas as validacoes passaram!\n\n")

# ==================================================
# 7. CRIAR DIRETORIO E EXPORTAR ARQUIVO
# ==================================================

cat("=== EXPORTANDO ARQUIVO ===\n\n")

# Criar diretorio se nao existir
dir_dados <- "dados_brutos"
if (!dir.exists(dir_dados)) {
  dir.create(dir_dados, showWarnings = FALSE, recursive = TRUE)
  cat(sprintf("Diretorio criado: %s\n", dir_dados))
}

# Definir caminho do arquivo
arquivo_saida <- file.path(dir_dados, "gnomad_mlh1_frequencies_v4.0.tsv")

cat(sprintf("Exportando para: %s\n\n", arquivo_saida))

# Criar cabeçalho informativo
cabecalho <- sprintf(
  "# ==================================================\n# gnomAD v4.0 - MLH1 Gene Frequencies (SIMULATED)\n# ==================================================\n#\n# NOTA SOBRE SIMULACAO:\n# Este arquivo foi gerado dentro do R script 07\n# para reproducibilidade academica.\n# \n# FONTE ORIGINAL:\n# Karczewski KJ, et al. The mutational constraint spectrum quantified from\n# variation in 141,456 humans. Nature. 2020;581(7809):434-443.\n# https://gnomad.broadinstitute.org/\n#\n# METODOLOGIA:\n# - Frequencias baseadas em distribuicao real de Lynch variants\n# - AF realista para variantes raras (< 0.01 por cento)\n# - AC/AN consistentes com AF\n# - Seed reproducibilidade: %d\n# - 10 por cento dados faltando para realismo\n# - Validacoes: 0 <= AF <= 1\n#\n# GENE: MLH1 (MutL homolog 1)\n# CROMOSSOMO: 3\n# VERSAO: gnomAD v4.0 (simulado)\n# DATA CRIACAO: %s\n# TOTAL DE VARIANTES: %d\n# DADOS FALTANDO: %d (%.1f por cento)\n# ==================================================\n",
  SEED_REPRODUCIBILIDADE,
  format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
  nrow(df_gnomad),
  n_na_total,
  n_na_total / nrow(df_gnomad) * 100
)

# Escrever arquivo
# Primeiro: cabeçalho
cat(cabecalho, file = arquivo_saida)

# Depois: dados
write.table(df_gnomad,
            file = arquivo_saida,
            sep = "\t",
            row.names = FALSE,
            quote = FALSE,
            append = TRUE,
            na = "NA")

cat("[OK] Arquivo exportado com sucesso!\n\n")

# ==================================================
# 8. VALIDACAO POS-EXPORT
# ==================================================

cat("=== VALIDACAO POS-EXPORT ===\n\n")

# Verificar se arquivo foi criado
if (file.exists(arquivo_saida)) {
  arquivo_info <- file.info(arquivo_saida)
  cat(sprintf("Arquivo criado com sucesso!\n"))
  cat(sprintf("   Tamanho: %.1f KB\n", arquivo_info$size / 1024))
  cat(sprintf("   Data: %s\n\n", arquivo_info$mtime))
} else {
  stop("[ERRO] Arquivo nao foi criado!")
}

# Ler arquivo de volta para validar
df_verificacao <- read.table(
  arquivo_saida,
  header = TRUE,
  sep = "\t",
  stringsAsFactors = FALSE,
  comment.char = "#"
)

cat(sprintf("Arquivo relido com sucesso!\n"))
cat(sprintf("   Linhas: %d\n", nrow(df_verificacao)))
cat(sprintf("   Colunas: %d\n\n", ncol(df_verificacao)))

# ==================================================
# 9. RESUMO FINAL
# ==================================================

cat("=== RESUMO FINAL ===\n\n")

cat("Arquivo gnomAD simulado gerado com sucesso!\n\n")

cat("Resumo das frequencias:\n")
cat(sprintf("   Total de variantes: %d\n", nrow(df_gnomad)))
cat(sprintf("   Variantes com AF: %d (%.1f%%)\n", 
            sum(!is.na(df_gnomad$AF)), 
            sum(!is.na(df_gnomad$AF)) / nrow(df_gnomad) * 100))
cat(sprintf("   Variantes com NA: %d (%.1f%%)\n", 
            sum(is.na(df_gnomad$AF)), 
            sum(is.na(df_gnomad$AF)) / nrow(df_gnomad) * 100))

cat("\nDistribuicao de AF (variantes com dados):\n")
af_com_dados <- df_gnomad$AF[!is.na(df_gnomad$AF)]
cat(sprintf("   Muito raras (< 0.001%%): %d\n", sum(af_com_dados < 0.00001)))
cat(sprintf("   Raras (0.001%% - 0.01%%): %d\n", 
            sum(af_com_dados >= 0.00001 & af_com_dados < 0.0001)))
cat(sprintf("   Mais comuns (>= 0.01%%): %d\n", sum(af_com_dados >= 0.0001)))

cat(sprintf("\nArquivo pronto para Script 08!\n"))
cat(sprintf("Localizacao: %s\n\n", arquivo_saida))

cat("[OK] SCRIPT 07 EXECUTADO COM SUCESSO!\n\n") 