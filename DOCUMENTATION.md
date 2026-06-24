# Clinical Trials Dataform Pipeline Documentation

This project contains 10 analytical pipelines for processing clinical trial data using Dataform Core v3.0+ and BigQuery (2026). It leverages advanced BigQuery features such as Vector Search, Graph Queries (GQL), and Generative AI.

## Project Structure

- `definitions/`: Contains `.sqlx` model files and `.js` source declarations.
- `workflow_settings.yaml`: Project configuration (Project ID: `meridian-dev-455515`, Dataset: `joe_demo_test`).
- `GEMINI.md`: Local context and rules for the agent.

---

## 1. Pipeline Definitions

### Semantic & Conceptual Search
1.  **Cancer Semantic Search** (`cancer_semantic_search.sqlx`)
    - **Purpose**: Identifies trials similar to "Cancer treated by MK-3475".
    - **Logic**: Uses `VECTOR_SEARCH` on `ClinicalTrialMasterData_flattened`.
2.  **Metabolic Semantic Search** (`metabolic_semantic_search.sqlx`)
    - **Purpose**: Locates trials related to "Metabolic diseases".
    - **Logic**: Vector search with `COSINE` distance and a `top_k` limit of 10.

### Hybrid Discovery
3.  **Immunotherapy Hybrid Search** (`immunotherapy_hybrid_search.sqlx`)
    - **Purpose**: Combines keyword filtering ("MK-3475") with semantic vector search.
    - **Logic**: Uses a subquery to pre-filter rows before applying `VECTOR_SEARCH`.
4.  **AstraZeneca Hybrid Search** (`astrazeneca_hybrid_search.sqlx`)
    - **Purpose**: Finds "chronic disease" studies specifically sponsored by AstraZeneca.
    - **Logic**: Lexical filter on `sponsor` column combined with vector lookup.

### Graph Traversal (GQL)
5.  **Bomedemstat Graph Relationships** (`bomedemstat_sponsors.sqlx`)
    - **Purpose**: Connects trials testing Bomedemstat to their sponsoring companies.
    - **Logic**: Uses `GRAPH_TABLE` with pattern `(Trial)-[:TestsDrug]->(Drug)-[:SponsoredBy]->(Sponsor)`.
6.  **Multi-Hop Drug Repurposing** (`phase3_multi_hop_traversal.sqlx`)
    - **Purpose**: Finds non-Phase-3 trials testing the same compounds as active Phase 3 trials.
    - **Logic**: Bidirectional traversal from `Trial1` to `Trial2` via a shared `Drug` node.

### Relational BI & Aggregations
7.  **Targeted Enrollment** (`phase3_targeted_enrollment.sqlx`)
    - **Purpose**: Sums total patient enrollment for all late-stage trials.
    - **Logic**: Broad `LIKE` filtering to capture varied Phase strings (`Phase III`, `PHASE3`, `Phase 3`).
8.  **Top Active Sponsors** (`top_active_sponsors.sqlx`)
    - **Purpose**: Ranks manufacturers by the count of active/completed trials.
    - **Logic**: Aggregation by `Sponsor` limited to the top 10.

### Generative AI & Metadata
9.  **AstraZeneca Clinical Metadata** (`astrazeneca_eligibility_criteria.sqlx`)
    - **Purpose**: Extracts eligibility criteria text for AstraZeneca trials.
    - **Logic**: Selective projection from the master dataset.
10. **AI Layman Synthesizer** (`bomedemstat_layman_comparison.sqlx`)
    - **Purpose**: Generates natural language summaries of trial drugs using Gemini.
    - **Logic**: Combines Vector Search, Graph Traversal, and `AI.GENERATE`.

---

## 2. Implementation Learnings

### BigQuery VECTOR_SEARCH Constraints
- **Logical Views Not Supported**: `VECTOR_SEARCH` cannot target a Dataform `view`. It requires a materialized `table` or a simple subquery containing only `SELECT` and `WHERE`.
- **Nested Fields**: The first argument of `VECTOR_SEARCH` cannot contain nested field expressions (e.g., `STRUCT.field`).
- **Intermediate Materialization**: To bypass these, we implemented a `ClinicalTrialMasterData_flattened` table to provide top-level embedding columns.

### BigQuery GRAPH_TABLE (GQL) Nuances
- **Syntax Precision**: Removed redundant commas between graph names and `MATCH` clauses which are common in older SQL patterns but rejected in GQL.
- **Case Sensitivity**: GQL labels (`TestsDrug`, `SponsoredBy`) and property names (`drug_name`) are strictly case-sensitive and must match the graph's schema exactly.

### Embedding Stability
- **Dimension Mismatch**: A single row with an empty embedding array (`[]`) can cause the entire vector search query to fail with an "Array inputs not equal in length" error.
- **Validation Rule**: Always filter for valid dimensions (e.g., `ARRAY_LENGTH(embedding) = 768`) in the data cleaning layer.

---

## 3. Blind Validation Discovery

- **The Gold Standard**: Validating against a "black box" dataset required iterative runtime analysis.
- **Dataset Pivot**: Discovered that `ClinicalTrialMasterData_embedded` lacked a functioning backend model, leading to a pivot to `ClinicalTrialMasterData_embedded2`.
- **Logic Alignment**: Discovered that "Phase 3" data exists in multiple string formats. Achieving 100% alignment required widening filters from strict equality (`= 'Phase 3'`) to broader patterns (`LIKE '%Phase III%'`).

---

## 4. Best Practices for Future Development

Based on this project's implementation, the following "Environment-Centric" rules should be followed for all new Dataform pipelines:

1.  **Schema-First Auditing**: Always run `bq show --format=json [table]` BEFORE authoring models. Mapping the physical schema (e.g., `StudyTitle` vs `title`) prevents multiple rework cycles.
2.  **Resource Probing**: Confirm the existence of AI connections (`meridian-dev-455515.us.cloud_ai_resources`) and specific endpoints (`gemini-2.5-flash`) early to choose the correct scalar functions.
3.  **Engine Constraint Awareness**:
    -   `VECTOR_SEARCH` requires materialized **Tables**, not Views.
    -   Flatten nested fields (like embeddings) in a base materialization layer.
4.  **Data Profiling**: For any filter (e.g., `Phase`), run `SELECT DISTINCT [column]` to identify all string variations (`Phase 3` vs `Phase III`) before writing logic.
5.  **Validation Sandboxing**: When validating logic, script baseline queries to a temporary dataset and use `EXCEPT DISTINCT` for mathematical proof of alignment.

---

## 5. Operational Instructions

### Compilation
```bash
npx @dataform/cli compile
```

### Execution
Ensure `.df-credentials.json` is configured with valid Project ID and Location.
```bash
npx @dataform/cli run
```

### Verification
Run validation queries provided in the `SCAFFOLDING_PLAN.md` or check row counts:
```sql
SELECT count(*) FROM `meridian-dev-455515.joe_demo_test.cancer_semantic_search`
```
