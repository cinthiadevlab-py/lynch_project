\# Lynch Syndrome Bioinformatics - Clinical Translational Analysis



\[!\[Status](https://img.shields.io/badge/Status-In%20Development-yellow)]()

\[!\[R Version](https://img.shields.io/badge/R-%3E%3D%204.0-blue)]()

\[!\[License](https://img.shields.io/badge/License-MIT-green)]()

\[!\[Maintenance](https://img.shields.io/badge/Maintenance-Active-brightgreen)]()



\## 🧬 Visão Geral



Este projeto implementa uma \*\*análise clínica translacional de variantes genéticas associadas à Síndrome de Lynch\*\*, focando no gene MLH1 e no sistema de reparo de incompatibilidades do DNA (MMR - Mismatch Repair).



\*\*Estágio atual:\*\* Etapa 6 de 15 completa (40% de progresso) ✅



\## 📋 Objetivo do Projeto



Caracterizar variantes patogênicas do gene MLH1 utilizando dados públicos de qualidade clínica, aplicando rigor científico e reprodutibilidade.



\## 🏗️ Estrutura do Projeto

lynch\_project/



├── README.md                  # Este arquivo



├── requirements.txt           # Dependências R



├── CONTRIBUTING.md            # Guia para contribuidores



├── .gitignore



├── lynch\_project.Rproj



│



├── dados\_brutos/              # Dados originais



│   └── insight/



│       └── clinvar\_mlh1\_patogenicas\_2026.txt (1.746 linhas)



│



├── dados\_processados/         # Dados processados



│   └── clinvar\_mlh1\_limpo.rds



│



├── scripts/                   # Análises em R



│   ├── 01\_modelo\_dados\_lynch.R ✅



│   ├── 02\_importacao\_dados.R ✅



│   ├── 03\_analise\_clinvar\_mlh1.R ✅



│   └── 04\_analises\_relacionais\_mlh1.R ✅



│



├── results/                   # Resultados



│   ├── top\_condicoes\_relacionais.csv ✅



│   ├── top\_consequencias.csv ✅



│   └── top\_tipos\_variantes.csv ✅



│



├── figures/                   # Gráficos



│   ├── grafico\_condicoes.png ✅



│   ├── grafico\_consequencias.png ✅



│   └── grafico\_tipos\_variantes.png ✅



│



└── reports/                   # Relatórios



├── relatorio\_mlh1.md ✅



└── relatorio\_mlh1.html ✅

\## 📊 Progresso do Projeto



| # | Etapa | Descrição | Status |

|---|-------|-----------|--------|

| 1 | Modelagem de Dados | Definir schema Lynch/MMR | ✅ |

| 2 | Importação ClinVar | Integrar 1.745 variantes MLH1 | ✅ |

| 3 | Análise Exploratória | Caracterização clínica e molecular | ✅ |

| 4 | Análises Relacionais | Relações entre variáveis + gráficos | ✅ |

| 5 | Relatório | Síntese científica dos resultados | ✅ |

| 6 | README + Docs | Documentação GitHub + requirements | ✅ |

| 7 | ACMG/AMP 2015 | Classificação formal de variantes | ⏳ |

| 8-15 | Futuras | Múltiplos bancos, splicing, pipeline | ⏳ |



\*\*Progresso Total: 6/15 etapas (40%)\*\* ✅



\## 🛠️ Tecnologias Utilizadas



\- \*\*R\*\* ≥4.0 - Análises e visualizações

\- \*\*tidyverse\*\* - Manipulação de dados

\- \*\*ggplot2\*\* - Gráficos

\- \*\*Git + GitHub\*\* - Versionamento

\- \*\*ClinVar\*\* - Banco de dados de variantes



\## 📥 Como Instalar e Executar



\### Pré-requisitos

\- R ≥ 4.0

\- Git

\- \~100 MB de espaço em disco



\### Instalação

```bash

git clone https://github.com/cinthiadevlab-py/lynch\_project.git

cd lynch\_project

```



\### Instalar dependências

```r

install.packages(c("readr", "dplyr", "ggplot2"))

```



\### Executar scripts

```r

source("scripts/01\_modelo\_dados\_lynch.R")

source("scripts/02\_importacao\_dados.R")

source("scripts/03\_analise\_clinvar\_mlh1.R")

source("scripts/04\_analises\_relacionais\_mlh1.R")

```



\## 📚 Referências Científicas



\- \*\*Richards et al. 2015\*\* - ACMG/AMP Standards (PMID: 25741868)

\- \*\*ClinVar\*\* - NCBI Variant Database

\- \*\*Síndrome de Lynch\*\* - Gene MLH1, MMR system



\## 🚀 Próximos Passos



\- Etapa 7: Implementar ACMG/AMP 2015

\- Etapa 8: Integrar InSiGHT + gnomAD

\- Etapa 9: Análise de Splicing avançado



\## 🤝 Como Contribuir



Veja \[CONTRIBUTING.md](CONTRIBUTING.md) para detalhes.



\## 📄 Licença



MIT License - Veja LICENSE para detalhes.



\---



\*\*Status:\*\* Em Desenvolvimento ✅  

\*\*Última atualização:\*\* Junho 2026  

\*\*Autor:\*\* Cinthia Morales



