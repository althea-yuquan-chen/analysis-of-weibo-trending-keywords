# Analysis of Weibo Trending Keywords

Empirical study of Weibo hot-search topics (2021–2023), examining how keyword length, topic category, time on the trending list, and sentiment intensity relate to popularity (hotness score).

> **Paper:** [Analysis of Weibo Trending Keywords](https://doi.org/10.54254/2755-2721/55/20241397) — *Applied and Computational Engineering*, Vol. 55 (2024)

---

## Repository Structure

```
.
├── data/
│   ├── hotlist.csv           # Raw crawl: daily Weibo trending entries Jan 2021 – Jul 2023
│   └── sort rules.xlsx       # Category-merging reference table
├── crawl.py                  # Step 0 – Web crawl: fetch daily trending lists from API
├── preprocessing.R           # Step 1 – Data cleaning, category merging, correlation analysis
├── descriptive_stats.R       # Step 1.5 – Exploratory visualisations (distributions, time series)
├── sentiment_nlp.py          # Step 2 – Sentiment scoring with SnowNLP
├── emotion_analysis.R        # Step 3 – Sentiment–hotness correlation & ANOVA
├── lgbm.ipynb                # Modelling – LightGBM classifier for hotness level
└── nnet.ipynb                # Modelling – Neural network classifier for hotness level
```

---

## Data

| File | Description |
|------|-------------|
| `data/hotlist.csv` | ~27 MB raw crawl: daily Weibo trending entries Jan 2021 – Jul 2023 |
| `data/sort rules.xlsx` | Category-merging reference table (Chinese → consolidated labels) |

Key columns in `hotlist.csv`: keyword name (名称), date (日期), hotness score (热度), time on list (上榜时间), category (分类).

---

## Pipeline

### Step 0 — Crawl (`crawl.py`)
Fetches the Weibo trending-list snapshot for every date in the 2021-01-01 to 2023-07-31 range via a third-party mirror API and appends results to `hotlist.csv`. Drops internal fields (`_id`, `icon`, `clickNum`, etc.) and renames columns to Chinese labels.

> **Before running:** update the `to_csv` path to your local output directory.

**Requirements:** `requests`, `pandas`

### Step 1 — Preprocessing (`preprocessing.R`)
- Removes outliers and missing values.
- Merges ~40 fine-grained categories into 13 consolidated groups (影视, 娱乐, 新闻, 游戏, 教育, 科技, 生活, 政治, 文化, 商业, 健康, 公益, 其他).
- Engineers features: character count (`wordcount`), character-count tier (`levelnchar`).
- Runs Pearson/Spearman correlations and one-way ANOVA between hotness and each feature.
- Outputs `sort_data.csv`.

> **Before running:** set the path in `read_csv("your path to hotlist")`.

**Requirements:** `readr`, `dplyr`, `stringr`, `do`, `ggplot2`, `stats`

### Step 1.5 — Descriptive Statistics (`descriptive_stats.R`)
Generates exploratory plots from `sort_data`:
- Category frequency bar chart
- Kernel density plot of hotness scores
- Monthly category frequency line chart
- Hotness-over-time line chart by category

**Requirements:** `ggplot2`, `ggthemes`

### Step 2 — Sentiment NLP (`sentiment_nlp.py`)
Uses [SnowNLP](https://github.com/isnowfy/snownlp) to compute a sentiment probability score (0–1) for each keyword name. Appends a `sentiment` column and outputs `emotion_data.csv`.

> **Before running:** update `csv_file` and `output_csv_file` paths.

**Requirements:** `pandas`, `snownlp`

### Step 3 — Emotion Analysis (`emotion_analysis.R`)
- Re-centres sentiment scores around 0 (subtracts 0.5).
- Computes Spearman correlation between sentiment and hotness (result: −0.03, not significant).
- Bins sentiment into three intensity levels: `weak` (|s| ≤ 0.15), `medium`, `strong` (|s| ≥ 0.35).
- ANOVA shows sentiment *level* (intensity) is significantly associated with hotness even though raw score is not.
- Produces sentiment distribution histogram and sentiment-level bar chart.

**Requirements:** `readr`, `ggplot2`, `stats`

### Modelling — LightGBM (`lgbm.ipynb`) and Neural Network (`nnet.ipynb`)
Both notebooks classify each topic into one of three hotness tiers (low / medium / high) using features from `work_data.csv` (category, time on list, character-count tier, sentiment level):

| Notebook | Model | Key libraries |
|----------|-------|---------------|
| `lgbm.ipynb` | LightGBM (GBDT, multiclass) | `lightgbm`, `scikit-learn` |
| `nnet.ipynb` | Fully-connected neural network | `tensorflow`/`keras`, `scikit-learn` |

Both notebooks use an 80/20 train-test split with Z-score normalisation.

> **Before running:** update the `work_data.csv` path in the first data-loading cell of each notebook.

---

## Reproducing the Analysis

```bash
# 1. Install Python dependencies
pip install requests pandas snownlp lightgbm tensorflow scikit-learn

# 2. Crawl data  (skip if using the provided data/hotlist.csv)
python crawl.py

# 3. R preprocessing pipeline
Rscript preprocessing.R
Rscript descriptive_stats.R

# 4. Sentiment scoring
python sentiment_nlp.py

# 5. Emotion analysis
Rscript emotion_analysis.R

# 6. Open and run modelling notebooks
jupyter notebook lgbm.ipynb
jupyter notebook nnet.ipynb
```

> **Note:** All scripts contain hardcoded local paths. Search for `read_csv`, `to_csv`, or path strings and update them to match your environment before running.

---

## Citation

```bibtex
@article{weibo-trending-2024,
  title   = {Analysis of Weibo Trending Keywords},
  journal = {Applied and Computational Engineering},
  volume  = {55},
  year    = {2024},
  doi     = {10.54254/2755-2721/55/20241397}
}
```