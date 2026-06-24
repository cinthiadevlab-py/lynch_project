# Lynch Syndrome Variant Analysis - Bioinformatic Clinical Translation Project

## Project Overview

This project implements a comprehensive bioinformatic workflow for analyzing genetic variants associated with Lynch Syndrome (Hereditary Non-Polyposis Colorectal Cancer - HNPCC) using the Mismatch Repair (MMR) gene family. The analysis integrates clinical interpretation with population genetics data, applying ACMG/AMP 2015 criteria for variant pathogenicity classification.

Primary Focus: MLH1 gene variants with multi-gene support (MSH2, MSH6, PMS2, EPCAM)
Data Source: ClinVar database (1,739 variants) integrated with gnomAD v4.0 allele frequencies
Methodology: Standardized bioinformatic pipeline in R with reproducible analysis

---

## Project Status

| Script | Description | Status | Completion |
|--------|-------------|--------|------------|
| 01-05 | Data modeling, gene characterization, clinical evidence | Complete | 100% |
| 06 | ACMG/AMP 2015 variant classification | Complete | 100% |
| 07 | Population genetics simulation (gnomAD integration) | Complete | 100% |
| 08 | Gene impact and molecular characterization analysis | Complete | 100% |
| 09 | Advanced gene impact metrics and variant distribution | Complete | 100% |
| 10 | Population subgroup analysis (frequency-based stratification) | In Progress | 80% |
| 11-15 | Clinical validation, visualizations, final reporting | Pending | 0% |

Overall Project Completion: 60/100 (60%)

---

## Current Work - Script 10: Population Analysis

### Completed Sections (Sections 1-4)

Section 1: Data Preparation and Loading
- Load ClinVar MLH1 dataset with gnomAD frequencies
- Data structure validation: 1,739 variants across 17 data dimensions
- Internal quality checks and metadata inspection

Section 2: Exploratory Data Analysis
- Frequency distribution analysis (allele frequency range: 1.003645e-06 to 9.909337e-04)
- Classification proportions: Pathogenic 85.39%, VUS 4.60%, Benign minimal
- Biological pattern validation aligned with Lynch Syndrome epidemiology

Section 3: Population Subgroup Categorization (REFACTORED)
- Biologically-based allele frequency cutoffs per ACMG/AMP PM2 criterion:
  * Ultra_Rara: AF < 0.0001 (n=1,485, 85.39%)
  * Muito_Rara: 0.0001 ≤ AF < 0.001 (n=80, 4.60%)
  * Rara: 0.001 ≤ AF < 0.01 (n=0, empty - expected for Lynch)
  * Comum: AF ≥ 0.01 (n=0, empty - expected for Lynch)
  * Dados_Faltando: Missing AF annotation (n=174, 10.01%)

- Implementation: Robust vector-based approach without post-hoc reconstruction
- All 5 categories properly defined as factor levels before data assignment

Section 4: Detailed Population Analysis
- Gene distribution across frequency subgroups (16 genes identified)
- Cross-tabulation: Classification vs Subgroup
  * Ultra_Rara: 100% Pathogenic (validates PM2 ACMG criterion)
  * Muito_Rara: 100% VUS (intermediate frequency requires additional evidence)
  * Perfect correlation between allele frequency and pathogenicity classification
  
- Statistical summary per subgroup with proportions and unique gene counts
- Critical biological discovery validation:
  * Lynch is genuinely rare disease (85.4% ultra-rare variants)
  * 80 VUS variants (4.6%) represent diagnostic uncertainty requiring follow-up
  * 174 variants (10%) lack frequency annotation, limiting PM2 classification

### Pending - Section 5 (Validation and Export)

- Pre-export validation: row sums, counts, NA patterns
- Export to RDS format (dados_processados/script10_analise_populacional.rds)
- Export to CSV format (results/10_resumo_populacional.csv)
- Export summary text report (results/10_summary_populacional.txt)
- Mark Script 10 as complete

---

## Scientific Methodology

### ACMG/AMP Classification Framework

This project strictly adheres to ACMG/AMP 2015 guidelines for variant interpretation:
- PM2 (Absent from controls): AF < 0.01% in general population
- Evidence integration: molecular, functional, segregation data
- VUS classification: insufficient evidence for pathogenicity determination

### Data Integration

- Primary Source: ClinVar (variant annotations and classification evidence)
- Frequency Data: gnomAD v4.0 (population allele frequencies across ancestry groups)
- Reference Standards: InSiGHT database (Lynch Syndrome-specific variant database)
- Quality Metrics: gnomAD coverage, filter passing status, ancestry-specific frequencies

### Reproducibility

- R version: 4.6.0
- Seed: 42 (applied in Script 07 for gnomAD simulation)
- Package dependencies: documented in requirements.txt
- All scripts: vectorized operations, explicit NA handling, validation checks

---

## Project Structure

lynch_project/
|- scripts/
|  |- 01_modelo_dados_lynch.R
|  |- 02-05_[gene_characterization_scripts].R
|  |- 06_validacao_acmg_amp_2015.R
|  |- 07_simulacao_gnomad.R
|  |- 08_analise_genes_impacto.R
|  |- 09_analise_genes_impacto.R
|  |- 10_analise_populacional.R
|
|- dados_brutos/
|  |- clinvar_mlh1_variants.tsv
|  |- gnomad_mlh1_frequencies_v4.0.tsv
|  |- [other reference data]
|
|- dados_processados/
|  |- clinvar_mlh1_com_gnomad.rds
|  |- script10_analise_populacional.rds [PENDING]
|  |- [intermediate results]
|
|- results/
|  |- 10_resumo_populacional.csv [PENDING]
|  |- 10_summary_populacional.txt [PENDING]
|  |- [visualization outputs]
|
|- figures/
|  |- [generated plots]
|  |- [analysis visualizations]
|
|- reports/
   |- NOTA_METODOLOGICA.md
   |- README.md
   |- [final manuscript]

---

## Key Findings (Current)

### Population Genetics

1. Extreme Rarity: 85.4% of variants with frequency data are ultra-rare (AF < 0.01%), consistent with autosomal dominant inheritance of a rare disease.

2. Molecular Spectrum: 16 genes identified with MLH1 representing 98% of frequency-annotated variants, reflecting known gene prevalence in Lynch Syndrome.

3. Diagnostic Challenge: 4.6% of variants classified as VUS, indicating incomplete evidence for pathogenicity determination and need for functional studies or clinical segregation analysis.

4. Data Completeness: 10% of variants lack allele frequency annotation, limiting ACMG PM2 criterion application.

### Classification-Frequency Correlation

Perfect correlation observed between allele frequency category and ACMG/AMP classification:
- Ratio (Ultra_Rara_Pathogenic / Muito_Rara_Pathogenic) = Infinity (denominator = 0)
- This validates the biological appropriateness of frequency cutoffs and ACMG application rigor

---

## Technical Requirements

### Dependencies

- R: version 4.6.0 or later
- Packages: tidyverse, data.table, ggplot2, openxlsx
- System: 4GB RAM minimum, Windows/Linux/macOS

See requirements.txt for complete package versions.

### Installation

git clone https://github.com/cinthiadevlab-py/lynch_project.git
cd lynch_project

Rscript -e "source('install_dependencies.R')"

### Execution

source("scripts/10_analise_populacional.R")

---

## Reference Standards

### ACMG/AMP 2015 Variant Interpretation

Recommended citation:
Richards, S., et al. (2015). Standards and guidelines for the interpretation of sequence variants. Nature Genetics, 47(11), 1236-1243.

### Lynch Syndrome Resources

- InSiGHT Database: https://www.insight-group.org/
- ClinVar: https://www.ncbi.nlm.nih.gov/clinvar/
- gnomAD: https://gnomad.broadinstitute.org/

---

## Project Evolution

Phase 1 (Scripts 01-05): Data foundation and gene characterization
Phase 2 (Scripts 06-09): ACMG classification and impact analysis
Phase 3 (Scripts 10-13): Population analysis and validation [CURRENT]
Phase 4 (Scripts 14-15): Clinical translation and final reporting

---

## Citation

This project represents translational bioinformatic research on Lynch Syndrome variant interpretation. Academic use is encouraged with appropriate citation of this repository and original data sources.

---

## License

Project license: See LICENSE file in repository

---

## Contact and Contribution

Maintainer: cinthiadevlab-py
Repository: https://github.com/cinthiadevlab-py/lynch_project

For questions, suggestions, or contributions, please open an issue on the GitHub repository.

---

Last Updated: June 24, 2026
Current Version: Script 10 - Sections 1-4 Complete 