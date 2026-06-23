# ==================================================
# SCRIPT DE PREPARACAO - ENVIRONMENT SETUP
# ==================================================
# Este script prepara o ambiente para executar
# Script 10 - Analise Populacional
#
# O QUE FAZ:
# 1. Cria estrutura de diretórios
# 2. Copia arquivos RDS dos uploads
# 3. Valida dados carregados
# ==================================================

cat("\n=== PREPARACAO DO AMBIENTE ===\n\n")

# 1. CRIAR ESTRUTURA DE DIRETORIOS
cat("Passo 1: Criando estrutura de diretorios...\n")

if (!dir.exists("dados_processados")) {
  dir.create("dados_processados", showWarnings = FALSE)
  cat("  [OK] Pasta 'dados_processados' criada\n")
} else {
  cat("  [OK] Pasta 'dados_processados' já existe\n")
}

if (!dir.exists("results")) {
  dir.create("results", showWarnings = FALSE)
  cat("  [OK] Pasta 'results' criada\n")
} else {
  cat("  [OK] Pasta 'results' já existe\n")
}

# 2. COPIAR ARQUIVO RDS NECESSARIO
cat("\nPasso 2: Localizando arquivo RDS...\n")

# Procurar em possíveis localizações
caminhos_possiveis <- c(
  "dados_processados/clinvar_mlh1_com_gnomad.rds",
  "clinvar_mlh1_com_gnomad.rds",
  "/mnt/user-data/uploads/clinvar_mlh1_com_gnomad.rds"
)

arquivo_encontrado <- FALSE
for (caminho in caminhos_possiveis) {
  if (file.exists(caminho)) {
    cat(sprintf("  [OK] Arquivo encontrado em: %s\n", caminho))
    arquivo_encontrado <- TRUE
    break
  }
}

if (!arquivo_encontrado) {
  cat("  [AVISO] clinvar_mlh1_com_gnomad.rds nao encontrado\n")
  cat("  Procurando arquivos alternativos...\n")
  
  # Procurar por arquivos RDS nos uploads
  arquivos_rds <- list.files("/mnt/user-data/uploads", pattern = "*.rds", full.names = TRUE)
  
  if (length(arquivos_rds) > 0) {
    cat(sprintf("  [OK] Encontrados %d arquivos RDS:\n", length(arquivos_rds)))
    for (i in 1:length(arquivos_rds)) {
      cat(sprintf("    %d. %s\n", i, basename(arquivos_rds[i])))
    }
    
    # Copiar o mais relevante (maior tamanho = mais dados)
    tamanhos <- file.size(arquivos_rds)
    arquivo_maior <- arquivos_rds[which.max(tamanhos)]
    
    cat(sprintf("\n  Copiando arquivo maior: %s\n", basename(arquivo_maior)))
    file.copy(arquivo_maior, "dados_processados/clinvar_mlh1_com_gnomad.rds", overwrite = TRUE)
    cat("  [OK] Arquivo copiado com sucesso!\n")
  }
}

# 3. VALIDAR ARQUIVO CARREGADO
cat("\nPasso 3: Carregando e validando dados...\n")

if (file.exists("dados_processados/clinvar_mlh1_com_gnomad.rds")) {
  df_teste <- readRDS("dados_processados/clinvar_mlh1_com_gnomad.rds")
  
  cat(sprintf("  [OK] Dados carregados com sucesso!\n"))
  cat(sprintf("    - Dimensoes: %d linhas x %d colunas\n", 
              nrow(df_teste), ncol(df_teste)))
  cat(sprintf("    - Colunas: %s\n", 
              paste(colnames(df_teste), collapse = ", ")))
  cat(sprintf("    - Genes unicos: %d\n", length(unique(df_teste$gene))))
  
  rm(df_teste)
} else {
  stop("[ERRO CRITICO] Nao foi possivel localizar arquivo RDS!")
}

# 4. RESUMO FINAL
cat("\n=== AMBIENTE PREPARADO ===\n\n")
cat("Estrutura criada:\n")
cat("  dados_processados/ - Arquivos RDS (entrada e saida)\n")
cat("  results/ - Resultados e graficos (saida)\n\n")

cat("Pronto para executar Script 10!\n")
cat("Execute: source('10_analise_populacional.R')\n\n")

cat("=== FIM DA PREPARACAO ===\n")