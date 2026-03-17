# 🏥 CMS Open Payments 2024 — Healthcare Financial Intelligence Platform

> A SQL-first, governance-aware analytics pipeline built on real CMS Open Payments data
> to detect conflict-of-interest patterns and quantify financial risk across 979K+ physicians.

---

## 📌 Project Overview

This project analyzes **15.3 million payment records** from the CMS Open Payments 
Program (2024) — a federal dataset tracking financial relationships between 
pharmaceutical/medical device companies and U.S. physicians.

The pipeline identifies anomalous payment patterns, segments physicians by conflict-of-interest 
risk, and quantifies an estimated **$17M in compliance exposure** across 1,390 
physicians with direct ownership conflicts.

---

## 🎯 Business Impact

| Metric | Value |
|--------|-------|
| Total Records Analyzed | 15,385,047 |
| Total Payment Volume | $3.31 Billion |
| Unique Physicians Profiled | 979,137 |
| Unique Pharma/Device Payers | 1,763 |
| Anomalous Payments Flagged (3σ) | 10 transactions >$116,450 threshold |
| Physicians with Ownership Conflicts | 1,390 |
| Estimated Compliance Exposure (15%) | $16,984,657 |

---

## 🗄️ Architecture — SQL-First EDW Pipeline
```
Raw CSVs (CMS.gov)
      │
      ▼
Chunked Ingestion        ← Handles 8.3GB file without memory crash
(50,000 rows/chunk)
      │
      ▼
SQLite EDW               ← Simulates Enterprise Data Warehouse
3 normalized tables:
  - general_payments     (15.3M rows × 91 cols)
  - research_payments    (756K rows  × 252 cols)
  - ownership_payments   (4.6K rows  × 30 cols)
      │
      ▼
HIPAA De-identification  ← SHA-256 pseudonymisation + audit log
(Safe Harbor Method)     45 CFR § 164.514(b) compliant
      │
      ▼
Advanced SQL Analytics   ← CTEs, Window Functions, NTILE, RANK()
      │
      ▼
Risk Scoring Engine      ← Custom conflict-of-interest scoring
      │
      ▼
Visualization Dashboard  ← Matplotlib 4-panel dashboard
```

---

## 🔬 SQL Techniques Demonstrated

| File | Technique |
|------|-----------|
| `01_top_specialties_by_payment.sql` | CTE + `RANK()` window function |
| `02_monthly_trends_running_total.sql` | CTE + `SUM() OVER()` running total |
| `03_physician_tier_segmentation.sql` | CTE + `NTILE(4)` segmentation |
| `04_conflict_of_interest_risk_score.sql` | CTE + weighted risk score formula |

---

## 🔒 HIPAA & Data Governance

- **Method:** Safe Harbor De-identification (18 PHI identifiers)
- **Technique:** SHA-256 one-way pseudonymisation (irreversible)
- **Fields Masked:** NPI, First Name, Last Name, City, ZIP Code
- **Compliance Standard:** HIPAA Privacy Rule — 45 CFR § 164.514(b)
- **Audit Log:** Full governance audit trail written to EDW

---

## 🚨 Key Findings

1. **Orthopaedic Surgery** received the highest total payments — $381.4M in 2024
2. **Endodontists** averaged $16,701 per payment — highest avg of any specialty
3. **Top 25% of physicians** received $2.53B out of $3.31B total (76% concentration)
4. **Single largest payment:** $91M to a Florida Endodontist from Edge Endo LLC
5. **BioNTech** paid $170M+ in COVID vaccine (COMIRNATY) royalties to a PA hospital
6. **February 2024** was the highest payment month at $386M

---

## 🛠️ Tech Stack

- **Language:** Python 3.x (Anaconda)
- **Database:** SQLite (EDW simulation)
- **Libraries:** Pandas, Matplotlib, Hashlib, Sqlite3
- **Data Source:** CMS Open Payments Program 2024
- **Notebook:** Jupyter Notebook

---

## 📁 Project Structure
```
hospital_cost_intelligence/
├── data/                        # Raw CMS CSV files
├── sql/                         # Standalone SQL query files
│   ├── 01_top_specialties_by_payment.sql
│   ├── 02_monthly_trends_running_total.sql
│   ├── 03_physician_tier_segmentation.sql
│   └── 04_conflict_of_interest_risk_score.sql
├── src/
│   └── 01_ingest_to_edw.ipynb   # Main analysis notebook
├── outputs/
│   ├── cms_open_payments.db     # SQLite EDW
│   └── cms_payments_dashboard.png
└── docs/
    └── README.md
```

---

## ▶️ How to Run

1. Download CMS Open Payments 2024 data from:
   👉 https://openpaymentsdata.cms.gov/datasets

2. Place all 3 CSV files in the `data/` folder

3. Open Jupyter Notebook and run `src/01_ingest_to_edw.ipynb` cell by cell

**Requirements:** Anaconda (Python 3.x) — all libraries pre-installed

---

## 👤 Author
**[Your Name]**
Healthcare Data Analyst | ASU
[Your LinkedIn] | [Your GitHub]
