# Clinical Trials Intelligence Platform 🏥 🧬

An autonomous clinical analytics platform featuring 10 multi-modal Dataform pipelines (Vector, Graph, AI), authored and validated in **record time (1h vs 8h)** by the **Gemini CLI Agent**.

[![BigQuery](https://img.shields.io/badge/BigQuery-Ready-blue?logo=google-cloud&logoColor=white)](https://cloud.google.com/bigquery)
[![Dataform](https://img.shields.io/badge/Dataform-v3.0+-green)](https://dataform.co/)
[![Healthcare IT](https://img.shields.io/badge/Healthcare-Intelligence-red)](https://github.com/chmstimoteo/clinical-trial-dataform)

---

## 🚀 Project Overview

This repository demonstrates how to leverage **BigQuery's 2026 multi-modal engine** to drive real business impact in the healthcare sector. The pipelines transition clinical trial data from raw relational rows into a live, semantic, and topological knowledge base.

### Key Capabilities:
- **Semantic Search**: Instant "concept-matching" across trial titles using 768-dim embeddings.
- **Graph Intelligence**: Multi-hop GQL traversals to identify drug repurposing opportunities.
- **Generative AI (RAG)**: Automated layman synthesis of complex clinical protocols using Gemini 2.5 Flash.

---

## 📂 Repository Structure

| File/Folder | Description |
| :--- | :--- |
| [`definitions/`](./definitions/) | Validated `.sqlx` models for all 10 analytical pipelines. |
| [`DOCUMENTATION.md`](./DOCUMENTATION.md) | **Technical Reference**: Architectural decisions and BigQuery engine learnings. |
| [`DEMO.md`](./DEMO.md) | **Multi-Agent Demo**: Journey of agent collaboration and validation. |
| [`DEPLOYMENT_GUIDE.md`](./DEPLOYMENT_GUIDE.md) | **Execution Guide**: Step-by-step instructions for local & cloud deployment. |
| [`GEMINI_CLI_AGENT_BRIEFING.md`](./GEMINI_CLI_AGENT_BRIEFING.md) | **Strategic Briefing**: Documentation of the 8x productivity gain. |
| [`gemini-cli-plans/`](./gemini-cli-plans/) | **Implementation Plans**: The canonical plan file for reproduction. |

---

## ⚡ Reproduce this work with Gemini CLI
You can autonomously reproduce this entire project using the Gemini CLI Agent:

1. Launch the agent: `gemini`
2. Instruct the agent to ingest the plan: 
   > "Load the file `gemini-cli-plans/clinical-trials-dataform-scaffolding.md` and execute Phase 1."
3. Follow the agent's prompts to compile, scaffold, and validate the pipelines phase-by-phase.

---

## 🛠️ The 10 Analytical Pipelines

### 🔍 Semantic & Hybrid Search
1.  **Cancer Semantic Search**: Find oncology trials by conceptual similarity.
2.  **Metabolic Semantic Search**: Target metabolic dysfunction studies semantically.
3.  **Immunotherapy Hybrid Search**: Combines keyword "MK-3475" with vector lookup.
4.  **AstraZeneca Hybrid Discovery**: Multi-layered search across sponsor and clinical content.

### 🕸️ Graph & Relationship Mapping
5.  **Bomedemstat Relationships**: GQL traversal linking trials, drugs, and sponsors.
6.  **Multi-Hop Drug Repurposing**: Identifying cross-phase opportunities for existing compounds.

### 📊 Relational BI & AI Synthesis
7.  **Targeted Enrollment**: Aggregated patient counts for Phase III/IV trials.
8.  **Top Active Sponsors**: Ranking manufacturers by active study volume.
9.  **Eligibility Extraction**: Precision extraction of AstraZeneca inclusion criteria.
10. **AI Layman Synthesizer**: End-to-end RAG pipeline for natural language clinician insights.

---

## ⚡ Quick Start

### 1. Compile the Project
```bash
npx @dataform/cli compile
```

### 2. Configure Credentials
Create a `.df-credentials.json` in the root:
```json
{
  "projectId": "YOUR_PROJECT_ID",
  "location": "us"
}
```

### 3. Execute Pipelines
```bash
npx @dataform/cli run
```

---

## 📚 Reference Materials

This project builds upon the foundational research and clinical trial dataset structures developed in the following repository:
- [Google Cloud: Document Analytics on BigQuery](https://github.com/GoogleCloudPlatform/document-analytics-on-bigquery)

This original work provided the clinical trial research framework, the multi-modal dataset schema, and the foundational analytical methodologies that were autonomously automated and scaled using the **Gemini CLI Agent**.

---

## 💡 Engineering Retrospective

This project was built using an **"Environment-Centric"** approach:
- **Proactive Schema Auditing**: Mapping BigQuery physical schemas before authoring.
- **Bypassing Engine Constraints**: Implementing flattened materialization for Vector Search.
- **Precision Validation**: Achieving 100% alignment with human "gold-standard" metrics.

> **Impact**: 1 hour of Agent-First development vs. 8 hours of manual engineering.

---
*Developed with ❤️ by the Gemini CLI Agent.*
