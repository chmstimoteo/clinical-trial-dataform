# Implementation Plan: Clinical Trials Dataform Scaffolding

This plan outlines the steps to autonomously generate, compile, and validate ten analytical pipelines on a multimodal clinical trials dataset using Dataform Core v3.0+.

## Objective
Scaffold 10 Dataform models (.sqlx) in the `definitions/` directory, verifying each one through compilation before proceeding to the next.

## Key Files & Context
- `workflow_settings.yaml`: Project configuration.
- `GEMINI.md`: Local context and rules for the agent.
- `definitions/*.sqlx`: Dataform model files.

## Implementation Steps

### Phase 1: Environment Setup
1. **Create `GEMINI.md`**: Define the GCP Project ID, Target Dataset, and clinical trial rules.
2. **Configure External Sources**: Create `definitions/sources.js` to declare external BigQuery tables, graphs, and AI models. Using `.js` files for declarations ensures they are correctly registered as data sources in Dataform Core v3.
3. **Verify Configuration**: Ensure `workflow_settings.yaml` is correctly pointed to `meridian-dev-455515` and `joe_demo_test`.

### Phase 2: Pipeline Execution & Assertions
For each of the 10 existing pipelines:
1. **Add Basic Assertions**: Update the `config` block of the existing `.sqlx` models to include `rowConditions` assertions on primary columns to ensure data quality without changing the business logic.
2. **Compile & Deploy**: Run `npx @dataform/cli compile` and then `npx @dataform/cli run` to deploy the models to the BigQuery dataset `joe_demo_test`.

### Phase 3: Blind Validation & Comparison
1. **Execute Validation Queries**: Run the user's provided "gold-standard" SQL queries directly in BigQuery.
2. **Comparison Analysis**: 
   - Compare row counts between the Dataform tables and the validation query outputs.
   - Compare a subsample of results to verify semantic alignment.
3. **Reporting**: Document any discrepancies between the Dataform models and the validation queries. Propose logic adjustments to the `.sqlx` files ONLY if they are technically flawed or diverge significantly from the intended goal of the original prompts.

## Post-Implementation Retrospective

The project was successfully completed, but subsequent analysis identified areas where the process could be optimized for future scale:

1.  **Environment-Centric Auditing**: Shifting from "Author-Centric" assumptions to proactive environment probing (using `bq show`) would have eliminated several rework cycles related to schema naming.
2.  **Structural Pre-Planning**: Architecting a materialization layer early would have bypassed BigQuery's `VECTOR_SEARCH` view/nesting limitations more efficiently.
3.  **Proactive Profiling**: Running data profiling on filter columns earlier would have caught Phase string variations (`Phase III`) during the initial authoring turn.

These learnings have been integrated into the **DOCUMENTATION.md** and **DEPLOYMENT_GUIDE.md**.
