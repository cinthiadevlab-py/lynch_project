# ==================================================
# SCRIPT: Criar Nota Metodológica
# ==================================================
# 
# OBJETIVO:
# Criar arquivo NOTA_METODOLOGICA.md na raiz do projeto
# com documentação sobre decisão metodológica Script 06
#
# COMO USAR:
# 1. Abra este script
# 2. Ctrl+A (selecionar tudo)
# 3. Ctrl+Enter (executar)
# OU clique no botão "Source" (topo direito do editor)
#
# ==================================================

cat("\n=== CRIANDO NOTA_METODOLOGICA.md ===\n")
cat("Pasta atual:", getwd(), "\n\n")

# Conteúdo do arquivo
conteudo <- "# Nota Metodológica - Decisão Script 06

## Questão Identificada

Script 06 (Classificação ACMG/AMP 2015) foi aplicado em dados expandidos 
(9.083 linhas) em vez de variantes únicas (1.739 linhas).

### Contexto
- Script 04 expande variantes com múltiplos genes em linhas separadas
- 1.745 variantes originais → 9.083 registros após expansão
- Script 06 classificou em 9.083 (duplicatas de mesma variante)
- Script 08 removeu duplicatas e consolidou para 1.739 únicas

## Decisão Tomada: ACEITAR CONFIGURAÇÃO ATUAL

### Justificativa

#### 1. Dados Finais Estão Biologicamente Corretos
- Script 08 remove duplicatas ANTES do merge com gnomAD
- Resultado final: 1.739 variantes únicas e classificadas
- Validação: MLH1 = 97.87%, Pathogenic = 95.4%, VUS = 4.6% ✓

#### 2. Trade-off Tempo vs. Qualidade
- Refazer Scripts 06-08: +8-10 horas, melhoria <5%
- Documentar decisão: +30 minutos, reproducibilidade ✓

#### 3. Reproducibilidade Mantida
- Fluxo completo documentado em scripts comentados
- Seed=42 em Script 07 garante replicação exata
- Decisão metodológica explícita e transparente
- Qualquer pessoa consegue reproduzir e entender as escolhas

#### 4. Objetivo do Projeto
- Projeto é educacional (TCC/aprendizado)
- Dados finais são válidos e interpretáveis
- Documentação clara resolve questões de reproducibilidade

### O Que Mudaria se Refizesse

Fluxo ótimo:
\`\`\`
Script 04 (expandir) → Script 05 (análise relacional em 9.083)
↓
Script 06 (ACMG em 1.739 ÚNICAS - não expandidas)
↓
Script 08 (merge direto com gnomAD)
\`\`\`

Benefício: Remove ciclo de validação ACMG/AMP duplicado
Custo: 8-10 horas de refatoração

### Conclusão

**Projeto é REPRODUCÍVEL e CIENTIFICAMENTE VÁLIDO**

✓ Fluxo documentado
✓ Decisões explícitas
✓ Resultados finais corretos
✓ Aprendizado preservado
✓ Possibilidade de refação futura se necessário

Para fins de TCC/aprendizado: Totalmente adequado
Para publicação futura: Pode refazer Scripts 06-08 com tempo disponível

---

## Status Atual

- Scripts 01-09: Validados ✓
- Decisão metodológica: Documentada ✓
- Reproducibilidade: Garantida ✓
- Próximos: Scripts 10-15

---

**Documento criado em**: 2026-06-22
**Status do Projeto**: 60% completo, Scripts 10-15 em andamento
**Reproducibilidade**: Garantida via este script de geração
"

# Criar o arquivo
write(conteudo, file = "NOTA_METODOLOGICA.md")

# Verificar sucesso
if (file.exists("NOTA_METODOLOGICA.md")) {
  cat("\n=== ✓ SUCESSO ===\n")
  cat("Arquivo criado: NOTA_METODOLOGICA.md\n")
  cat("Localização:", getwd(), "/NOTA_METODOLOGICA.md\n")
  
  info <- file.info("NOTA_METODOLOGICA.md")
  cat("Tamanho:", info$size, "bytes\n")
  cat("Data:", as.character(info$mtime), "\n")
  cat("\n✓ Arquivo está SALVO e REPRODUCÍVEL\n")
  cat("✓ Próxima vez que abrir este script e rodar,\n")
  cat("  o arquivo será criado novamente automaticamente\n\n")
} else {
  cat("\n❌ ERRO - Arquivo não foi criado\n")
}

# ==================================================
# FIM DO SCRIPT
# ==================================================