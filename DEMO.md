# Demo: Multi-Agent Clinical Intelligence Scaffolding

This demo showcases a real-world journey of **Multi-Agent Collaboration** in the healthcare sector. It demonstrates how two distinct agents—the **Data Engineering Agent (Gemini CLI)** and the **Conversational Analytics Agent (BigQuery)**—partnered to build, validate, and refine a production-ready clinical analytics platform.

---

## 🎭 The Cast of Agents

1.  **The Data Engineering Agent (Gemini CLI)**:
    - **Role**: Technical Architect & Builder.
    - **Action**: Authored 10 complex Dataform pipelines (`.sqlx`) from clinical prompts, autonomously resolving BigQuery engine constraints and materialization strategies.
2.  **The Conversational Analytics Agent (BigQuery)**:
    - **Role**: Data Scientist & Validator.
    - **Action**: Generated "Gold Standard" SQL queries to verify the clinical accuracy of the authored pipelines, ensuring results matched real-world research expectations.

---

## 🧬 Pipeline & Validation Showcase

Below are the key milestones where the agents collaborated to ensure clinical-grade data products.

### 🔍 Search Intelligence: Semantic & Hybrid

| Clinical Question | Authored Pipeline (.sqlx) | Validation Query (Truth Source) | "Wow" Effect |
| :--- | :--- | :--- | :--- |
| *Cancer semantic search* | [`cancer_semantic_search.sqlx`](./definitions/cancer_semantic_search.sqlx) | `AI.SEARCH` | **Auto-Flattening**: Materialized a flattened view to bypass BigQuery nested-field constraints. |
| *Immunotherapy hybrid* | [`immunotherapy_hybrid_search.sqlx`](./definitions/immunotherapy_hybrid_search.sqlx) | `AI.SEARCH` (Hybrid) | **Schema-Mapping**: Resolved hybrid lexical/semantic filters autonomously. |

### 🕸️ Graph Intelligence: Topological Discovery

| Clinical Question | Authored Pipeline (.sqlx) | Validation Query (Truth Source) | "Wow" Effect |
| :--- | :--- | :--- | :--- |
| *Bomedemstat sponsors* | [`bomedemstat_sponsors.sqlx`](./definitions/bomedemstat_sponsors.sqlx) | `GRAPH_TABLE` | **Zero-Shot GQL**: Authored complex GQL patterns to traverse drug-sponsor links without training. |
| *Drug repurposing paths* | [`phase3_multi_hop_traversal.sqlx`](./definitions/phase3_multi_hop_traversal.sqlx) | `GRAPH_TABLE` (Multi-hop) | **Multi-Hop Traversal**: Automates discovery of shared compounds across trial phases. |

### 📊 Relational BI & AI Synthesis

| Clinical Question | Authored Pipeline (.sqlx) | Validation Query (Truth Source) | "Wow" Effect |
| :--- | :--- | :--- | :--- |
| *Phase 3 enrollment* | [`phase3_targeted_enrollment.sqlx`](./definitions/phase3_targeted_enrollment.sqlx) | `SUM(Targeted_Enrollment)` | **Blind Validation Fix**: Agent identified & fixed Phase string format mismatches autonomously. |
| *AI layman synthesis* | [`bomedemstat_layman_comparison.sqlx`](./definitions/bomedemstat_layman_comparison.sqlx) | `AI.GENERATE` | **Full-Stack RAG**: Integrates vector search, graph paths, and generative insights in one node. |

---

## 🛠️ Validation Artifacts

To reproduce this blind validation process, refer to the following repository files:

- **[VALIDATION_QUERIES.sql](./VALIDATION_QUERIES.sql)**: The complete set of 10 gold-standard queries used as the objective "Truth Source".
- **[VALIDATION_JOURNEY.md](./VALIDATION_JOURNEY.md)**: The technical methodology documenting how we isolated the authoring agent from the validation agent to prove logical correctness.

---

## 🏆 The "Wow" Conclusion

This demonstration proves that by using **Gemini CLI**, we achieved:
- **8x Productivity**: 1 hour of active work vs. 8 hours of manual coding.
- **Agent-First Governance**: The BigQuery Analytics Agent provided the "Truth," and the Gemini CLI Agent provided the "Implementation."
- **Autonomous Recovery**: The agents handled schema mismatches, engine limitations, and data inconsistencies without human intervention.

> **"Your Data Team is no longer a bottleneck; they are the governors of a self-building analytics ecosystem."**
