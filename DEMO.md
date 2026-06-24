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

| Clinical Question | Authored Pipeline (.sqlx) | Validation Query (BigQuery Agent) | Resolution & "Wow" Effect |
| :--- | :--- | :--- | :--- |
| *"Find clinical trials studying treatments for cancer."* | [`cancer_semantic_search.sqlx`](./definitions/cancer_semantic_search.sqlx) | `SELECT base.StudyTitle FROM AI.SEARCH(...)` | **Agent Autonomy**: Gemini CLI identified that `VECTOR_SEARCH` requires a materialized table and autonomously built a flattened base layer to ensure execution. |
| *"Find immunotherapy trials testing drug MK-3475."* | [`immunotherapy_hybrid_search.sqlx`](./definitions/immunotherapy_hybrid_search.sqlx) | `SELECT base.StudyTitle FROM AI.SEARCH(..., mode => 'hybrid')` | **Engine Mastery**: Gemini CLI implemented a hybrid pre-filter in Dataform that perfectly matched the BigQuery Agent's native hybrid mode results. |

### 🕸️ Graph Intelligence: Topological Discovery

| Clinical Question | Authored Pipeline (.sqlx) | Validation Query (BigQuery Agent) | Resolution & "Wow" Effect |
| :--- | :--- | :--- | :--- |
| *"Which companies sponsor Bomedemstat trials?"* | [`bomedemstat_sponsors.sqlx`](./definitions/bomedemstat_sponsors.sqlx) | `SELECT * FROM GRAPH_TABLE(...)` | **Zero-to-One**: Authored complex GQL without the team needing to learn Graph Query Language. Corrected case-sensitive labels (`TestsDrug`) via runtime feedback. |
| *"Identify shared compounds in Phase 3 trials."* | [`phase3_multi_hop_traversal.sqlx`](./definitions/phase3_multi_hop_traversal.sqlx) | `MATCH (t1)-[:TestsDrug]->(d)<-[:TestsDrug]-(t2)` | **Multi-Hop Traversal**: Automated the mapping of repurposed drugs across different trial phases—a task that typically requires hours of manual SQL. |

### 📊 Relational BI & AI Synthesis

| Clinical Question | Authored Pipeline (.sqlx) | Validation Query (BigQuery Agent) | Resolution & "Wow" Effect |
| :--- | :--- | :--- | :--- |
| *"Total targeted enrollment for Phase 3."* | [`phase3_targeted_enrollment.sqlx`](./definitions/phase3_targeted_enrollment.sqlx) | `SUM(Targeted_Enrollment) WHERE Phase LIKE '%Phase III%'` | **Blind Validation Fix**: The BigQuery Agent revealed that enrollment was being undercounted. Gemini CLI refined the filter to catch varied string formats (`Phase III`, `PHASE3`). |
| *"Compare Bomedemstat trials in layman's terms."* | [`bomedemstat_layman_comparison.sqlx`](./definitions/bomedemstat_layman_comparison.sqlx) | `SELECT AI.GENERATE(...)` | **Full-Stack AI**: Combined vector search, graph paths, and Gemini 2.5 Flash synthesis into a single automated node. |

---

## 🏆 The "Wow" Conclusion

This demonstration proves that by using **Gemini CLI**, we achieved:
- **8x Productivity**: 1 hour of active work vs. 8 hours of manual coding.
- **Agent-First Governance**: The BigQuery Analytics Agent provided the "Truth," and the Gemini CLI Agent provided the "Implementation."
- **Autonomous Recovery**: The agents handled schema mismatches, engine limitations, and data inconsistencies without human intervention.

> **"Your Data Team is no longer a bottleneck; they are the governors of a self-building analytics ecosystem."**
