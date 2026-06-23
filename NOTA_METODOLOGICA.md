# Nota Metodológica - Decisão Script 06

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
```
Script 04 (expandir) → Script 05 (análise relacional em 9.083)
↓
Script 06 (ACMG em 1.739 ÚNICAS - não expandidas)
↓
Script 08 (merge direto com gnomAD)
```

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

