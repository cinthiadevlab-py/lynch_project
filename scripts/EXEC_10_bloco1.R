# ==================================================
# BLOCO 1: EXPLORAR DADOS ORIGINAIS
# ==================================================

rm(list = ls())
gc()

cat("\n=== BLOCO 1: EXPLORAR DADOS ORIGINAIS ===\n\n")

# Carregar dados do Script 09
df_original <- readRDS("dados_processados/clinvar_mlh1_com_gnomad.rds")

cat("Dados carregados:\n")
cat(sprintf("Dimensoes: %d linhas x %d colunas\n\n", 
            nrow(df_original), ncol(df_original)))

# ===== COMANDO 1: Estrutura dos dados =====
cat("\n=== COMANDO 1: ESTRUTURA DOS DADOS ===\n")
cat("O que faz: Mostra tipo de cada coluna e resumo\n")
cat("Por que: Precisamos validar se dados estao corretos\n\n")

str(df_original)

# ===== COMANDO 2: Primeiras linhas =====
cat("\n\n=== COMANDO 2: PRIMEIRAS LINHAS ===\n")
cat("O que faz: Mostra 10 primeiros registros completos\n")
cat("Por que: Ver dados reais (não só tipos)\n\n")

head(df_original, 10)

# ===== COMANDO 3: Resumo estatístico =====
cat("\n\n=== COMANDO 3: RESUMO ESTATISTICO ===\n")
cat("O que faz: Estatísticas básicas (média, mediana, etc)\n")
cat("Por que: Entender distribuição dos dados numéricos\n\n")

summary(df_original)

cat("\n\n=== COMANDO 3 EXTRA: Distribuição de classificações ===\n")
cat("Importantes para Script 10:\n\n")# ==================================================
> # BLOCO 1: EXPLORAR DADOS ORIGINAIS
> # ==================================================
> 
> rm(list = ls())
> gc()
          used (Mb) gc trigger  (Mb) max used  (Mb)
Ncells 1769670 94.6    2869788 153.3  2869788 153.3
Vcells 3872169 29.6    8388608  64.0  7679425  58.6
> 
> cat("\n=== BLOCO 1: EXPLORAR DADOS ORIGINAIS ===\n\n")

=== BLOCO 1: EXPLORAR DADOS ORIGINAIS ===

> 
> # Carregar dados do Script 09
> df_original <- readRDS("dados_processados/clinvar_mlh1_com_gnomad.rds")
> 
> cat("Dados carregados:\n")
Dados carregados:
> cat(sprintf("Dimensoes: %d linhas x %d colunas\n\n", 
+             nrow(df_original), ncol(df_original)))
Dimensoes: 1739 linhas x 17 colunas

> 
> # ===== COMANDO 1: Estrutura dos dados =====
> cat("\n=== COMANDO 1: ESTRUTURA DOS DADOS ===\n")

=== COMANDO 1: ESTRUTURA DOS DADOS ===
> cat("O que faz: Mostra tipo de cada coluna e resumo\n")
O que faz: Mostra tipo de cada coluna e resumo
> cat("Por que: Precisamos validar se dados estao corretos\n\n")
Por que: Precisamos validar se dados estao corretos

> 
> str(df_original)
'data.frame':	1739 obs. of  17 variables:
 $ variant_id                      : chr  "Single allele" "GRCh38/hg38 3p26.3-22.2(chr3:52266-37148076)x3" "GRCh38/hg38 3p26.3-22.1(chr3:53308-41381521)x3" "GRCh38/hg38 3p25.3-22.2(chr3:11463328-38919543)x3" ...
 $ gene                            : chr  "LOC126806655" "AZI2" "ACAA1" "LOC129936342" ...
 $ consequencia                    : chr  "" "" "" "" ...
 $ germline_classification_original: chr  "Pathogenic" "Pathogenic" "Pathogenic" "Pathogenic" ...
 $ gnomad_af                       : num  NA NA NA NA NA NA NA NA NA NA ...
 $ gnomad_ac                       : int  NA NA NA NA NA NA NA NA NA NA ...
 $ gnomad_an                       : int  NA NA NA NA NA NA NA NA NA NA ...
 $ gnomad_homozygotes              : int  NA NA NA NA NA NA NA NA NA NA ...
 $ af_categoria                    : chr  "Muito rara (< 0.01%)" "Muito rara (< 0.01%)" "Dados faltando (NA)" "Dados faltando (NA)" ...
 $ af_criterio_acmg                : chr  "PM2" "PM2" "NA (dados faltando)" "NA (dados faltando)" ...
 $ anotacao_status                 : chr  "pendente" "pendente" "pendente" "pendente" ...
 $ anotacao_timestamp              : chr  NA NA NA NA ...
 $ AF                              : num  9.23e-06 9.43e-06 NA NA 6.78e-06 ...
 $ AC                              : int  1 1 NA NA 1 NA 1 NA 1 1 ...
 $ AN                              : int  141456 141456 141456 141456 141456 141456 141456 141456 141456 141456 ...
 $ homozygotes                     : int  0 0 0 0 0 0 0 0 0 0 ...
 $ classificacao_final             : chr  "Pathogenic (PM2+)" "Pathogenic (PM2+)" "Likely Pathogenic (NA+P)" "Likely Pathogenic (NA+P)" ...
> 
> # ===== COMANDO 2: Primeiras linhas =====
> cat("\n\n=== COMANDO 2: PRIMEIRAS LINHAS ===\n")


=== COMANDO 2: PRIMEIRAS LINHAS ===
> cat("O que faz: Mostra 10 primeiros registros completos\n")
O que faz: Mostra 10 primeiros registros completos
> cat("Por que: Ver dados reais (não só tipos)\n\n")
Por que: Ver dados reais (não só tipos)

> 
> head(df_original, 10)
                                          variant_id         gene consequencia
1                                      Single allele LOC126806655             
2     GRCh38/hg38 3p26.3-22.2(chr3:52266-37148076)x3         AZI2             
3     GRCh38/hg38 3p26.3-22.1(chr3:53308-41381521)x3        ACAA1             
4  GRCh38/hg38 3p25.3-22.2(chr3:11463328-38919543)x3 LOC129936342             
5  GRCh38/hg38 3p22.3-22.1(chr3:33728406-40662451)x3        ACAA1             
6       GRCh38/hg38 3p22.2(chr3:36828515-37007227)x1     EPM2AIP1             
7            NM_000249.3(MLH1):c.-54519_1731+2263del LOC129936470             
8        NC_000003.12:g.(?_36993051)_(37012109_?)del     EPM2AIP1             
9        NC_000003.12:g.(?_36993051)_(36996719_?)del     EPM2AIP1             
10       NC_000003.12:g.(?_36993051)_(37028942_?)del     EPM2AIP1             
   germline_classification_original gnomad_af gnomad_ac gnomad_an gnomad_homozygotes
1                        Pathogenic        NA        NA        NA                 NA
2                        Pathogenic        NA        NA        NA                 NA
3                        Pathogenic        NA        NA        NA                 NA
4                        Pathogenic        NA        NA        NA                 NA
5                        Pathogenic        NA        NA        NA                 NA
6                        Pathogenic        NA        NA        NA                 NA
7                        Pathogenic        NA        NA        NA                 NA
8                        Pathogenic        NA        NA        NA                 NA
9                        Pathogenic        NA        NA        NA                 NA
10                       Pathogenic        NA        NA        NA                 NA
           af_categoria    af_criterio_acmg anotacao_status anotacao_timestamp           AF AC
1  Muito rara (< 0.01%)                 PM2        pendente               <NA> 9.233254e-06  1
2  Muito rara (< 0.01%)                 PM2        pendente               <NA> 9.433679e-06  1
3   Dados faltando (NA) NA (dados faltando)        pendente               <NA>           NA NA
4   Dados faltando (NA) NA (dados faltando)        pendente               <NA>           NA NA
5  Muito rara (< 0.01%)                 PM2        pendente               <NA> 6.775710e-06  1
6   Dados faltando (NA) NA (dados faltando)        pendente               <NA>           NA NA
7  Muito rara (< 0.01%)                 PM2        pendente               <NA> 7.629295e-06  1
8   Dados faltando (NA) NA (dados faltando)        pendente               <NA>           NA NA
9  Muito rara (< 0.01%)                 PM2        pendente               <NA> 6.912931e-06  1
10 Muito rara (< 0.01%)                 PM2        pendente               <NA> 7.345583e-06  1
       AN homozygotes      classificacao_final
1  141456           0        Pathogenic (PM2+)
2  141456           0        Pathogenic (PM2+)
3  141456           0 Likely Pathogenic (NA+P)
4  141456           0 Likely Pathogenic (NA+P)
5  141456           0        Pathogenic (PM2+)
6  141456           0 Likely Pathogenic (NA+P)
7  141456           0        Pathogenic (PM2+)
8  141456           0 Likely Pathogenic (NA+P)
9  141456           0        Pathogenic (PM2+)
10 141456           0        Pathogenic (PM2+)
> 
> # ===== COMANDO 3: Resumo estatístico =====
> cat("\n\n=== COMANDO 3: RESUMO ESTATISTICO ===\n")


=== COMANDO 3: RESUMO ESTATISTICO ===
> cat("O que faz: Estatísticas básicas (média, mediana, etc)\n")
O que faz: Estatísticas básicas (média, mediana, etc)
> cat("Por que: Entender distribuição dos dados numéricos\n\n")
Por que: Entender distribuição dos dados numéricos

> 
> summary(df_original)
     variant_id          gene         consequencia  germline_classification_original
 Length   :1739   Length   :1739   Length   :1739   Length   :1739                  
 N.unique :1739   N.unique :  16   N.unique :  70   N.unique :   2                  
 N.blank  :   0   N.blank  :   0   N.blank  : 187   N.blank  :   0                  
 Min.nchar:  13   Min.nchar:   4   Min.nchar:   0   Min.nchar:  10                  
 Max.nchar: 269   Max.nchar:  12   Max.nchar:  86   Max.nchar:  28                  
                                                                                    
                                                                                    
   gnomad_af      gnomad_ac      gnomad_an    gnomad_homozygotes    af_categoria 
 Min.   : NA    Min.   : NA    Min.   : NA    Min.   : NA        Length   :1739  
 1st Qu.: NA    1st Qu.: NA    1st Qu.: NA    1st Qu.: NA        N.unique :   3  
 Median : NA    Median : NA    Median : NA    Median : NA        N.blank  :   0  
 Mean   :NaN    Mean   :NaN    Mean   :NaN    Mean   :NaN        Min.nchar:  17  
 3rd Qu.: NA    3rd Qu.: NA    3rd Qu.: NA    3rd Qu.: NA        Max.nchar:  20  
 Max.   : NA    Max.   : NA    Max.   : NA    Max.   : NA                        
 NAs    :1739   NAs    :1739   NAs    :1739   NAs    :1739                       
  af_criterio_acmg  anotacao_status anotacao_timestamp       AF                  AC         
 Length   :1739    Length   :1739   Length   :1739     Min.   :1.004e-06   Min.   :  0.000  
 N.unique :   3    N.unique :   1   N.unique :   0     1st Qu.:3.746e-06   1st Qu.:  1.000  
 N.blank  :   0    N.blank  :   0   N.blank  :   0     Median :6.427e-06   Median :  1.000  
 Min.nchar:   3    Min.nchar:   8   Min.nchar:  NA     Mean   :3.909e-05   Mean   :  5.486  
 Max.nchar:  29    Max.nchar:   8   Max.nchar:  NA     3rd Qu.:9.325e-06   3rd Qu.:  1.000  
                                    NAs      :1739     Max.   :9.909e-04   Max.   :140.000  
                                                       NAs    :174         NAs    :174      
       AN          homozygotes classificacao_final
 Min.   :141456   Min.   :0    Length   :1739     
 1st Qu.:141456   1st Qu.:0    N.unique :   3     
 Median :141456   Median :0    N.blank  :   0     
 Mean   :141456   Mean   :0    Min.nchar:  17     
 3rd Qu.:141456   3rd Qu.:0    Max.nchar:  24     
 Max.   :141456   Max.   :0                       
                                                  
> 
> cat("\n\n=== COMANDO 3 EXTRA: Distribuição de classificações ===\n")


=== COMANDO 3 EXTRA: Distribuição de classificações ===
> cat("Importantes para Script 10:\n\n")
Importantes para Script 10:

> print(table(df_original$classificacao_final))

Likely Pathogenic (NA+P)        Pathogenic (PM2+)   VUS (AF intermediária) 
                     174                     1485                       80 
> 
> cat("\nProporção (%):\n")

Proporção (%):
> print(round(prop.table(table(df_original$classificacao_final)) * 100, 2))

Likely Pathogenic (NA+P)        Pathogenic (PM2+)   VUS (AF intermediária) 
                   10.01                    85.39                     4.60 
> 
> cat("\n=== FIM BLOCO 1 ===\n") 

=== FIM BLOCO 1 ===
>
print(table(df_original$classificacao_final))

cat("\nProporção (%):\n")
print(round(prop.table(table(df_original$classificacao_final)) * 100, 2))

cat("\n=== FIM BLOCO 1 ===\n") 