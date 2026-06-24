# Blind Validation Journey: Multi-Agent Process Documentation

This document outlines the systematic, isolated process used to ensure the Dataform pipelines (authored by the Data Engineering Agent) match the clinical "Truth Source" (provided by the Conversational Analytics Agent).

---

## The Workflow

To ensure "Blind Validation," we enforced a strict separation between the **Authoring Layer** and the **Verification Layer**.

### Step 1: Isolated Pipeline Authoring
- The **GEMINI CLI Agent** analyzed the high-level clinical questions.
- It scaffolded the Dataform models (`.sqlx`) independently, without access to the gold-standard validation queries.
- **Constraints Applied**: Mandatory schema flattening, embedding dimensional validation (`ARRAY_LENGTH = 768`), and native BigQuery function usage (`AI.EMBED`, `GRAPH_TABLE`).

### Step 2: "Gold Standard" Extraction
- The **Conversational Analytics Agent** generated the "Validation Queries" based on documented platform research.
- These queries represent the desired clinical insight, independent of how the Dataform DAG was implemented.

### Step 3: Independent Execution
- Pipelines were executed via `npx @dataform/cli run`, materializing results into production tables in `joe_demo_test`.
- Validation Queries were executed separately via the BigQuery CLI (`bq query`), creating a temporary, side-by-side comparison of results.

### Step 4: Comparison & Refinement Loop
- **Row Count Comparison**: Initial checks revealed discrepancies in pipeline 7 (Enrollment).
- **Semantic Alignment**: The Data Engineering Agent compared pipeline output vs. validation output.
- **Refinement**:
    - **Refinement 1 (Schema Mapping)**: Maps generic columns to actual names (e.g., `StudyTitle`).
    - **Refinement 2 (Logic Expansion)**: Pipeline 7 was updated to include broader string filters (`Phase III`, `PHASE3`) after comparing results against the gold standard.
    - **Refinement 3 (Materialization)**: Switched to `ClinicalTrialMasterData_flattened` to enable `VECTOR_SEARCH` compliance.

---

## Why This Matters

This multi-agent process eliminates **confirmation bias** in engineering. By forcing the authoring agent to construct logic without seeing the "answer key" until after deployment, we ensured that the final pipeline code is robust, technically accurate, and truly representative of the clinical data’s topology, not just a carbon copy of a validation query.
