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
2. **Configure External Sources**: Create `definitions/sources.js` and `definitions/ai_model.js` to declare external BigQuery tables, graphs, and AI models. Using `.js` files for declarations ensures they are correctly registered as data sources in Dataform Core v3.
3. **Verify Configuration**: Ensure `workflow_settings.yaml` is correctly pointed to `meridian-dev-455515` and `joe_demo_test`.

### Phase 2: Incremental Pipeline Generation & Testing
For each of the following prompts, the agent will:
1. Create the `.sqlx` file in the `definitions/` directory.
2. Run `npx dataform compile` to verify syntax and schema references.
3. Address any compilation errors before moving to the next prompt.

**Pipelines to Generate:**
1. **Cancer Semantic Search**: `definitions/cancer_semantic_search.sqlx`
2. **Metabolic Semantic Search**: `definitions/metabolic_semantic_search.sqlx`
3. **Immunotherapy Hybrid Search**: `definitions/immunotherapy_hybrid_search.sqlx`
4. **AstraZeneca Hybrid Search**: `definitions/astrazeneca_hybrid_search.sqlx`
5. **Bomedemstat Graph Relationships**: `definitions/bomedemstat_sponsors.sqlx`
6. **Multi-Hop Drug Repurposing Graph**: `definitions/phase3_multi_hop_traversal.sqlx`
7. **Relational Targeted Enrollment**: `definitions/phase3_targeted_enrollment.sqlx`
8. **Top Active Trial Sponsors**: `definitions/top_active_sponsors.sqlx`
9. **AstraZeneca Clinical Metadata**: `definitions/astrazeneca_eligibility_criteria.sqlx`
10. **AI Layman Comparison Synthesizer**: `definitions/bomedemstat_layman_comparison.sqlx`

## Post-Implementation Retrospective

The project was successfully completed, but subsequent analysis identified areas where the process could be optimized for future scale:

1.  **Environment-Centric Auditing**: Shifting from "Author-Centric" assumptions to proactive environment probing (using `bq show`) would have eliminated several rework cycles related to schema naming.
2.  **Structural Pre-Planning**: Architecting a materialization layer early would have bypassed BigQuery's `VECTOR_SEARCH` view/nesting limitations more efficiently.
3.  **Proactive Profiling**: Running data profiling on filter columns earlier would have caught Phase string variations (`Phase III`) during the initial authoring turn.

These learnings have been integrated into the **DOCUMENTATION.md** and **DEPLOYMENT_GUIDE.md**.
