# Deployment and Execution Guide: Clinical Trials Dataform

This guide provides step-by-step instructions on how to compile, execute, and deploy the clinical trials analytical pipelines on Google Cloud using Dataform Core v3.0+.

---

## 1. Prerequisites

Before starting, ensure you have the following:
- **Google Cloud Project**: `meridian-dev-455515` (or your target project).
- **BigQuery Dataset**: `joe_demo_test` created in the `us` location.
- **Node.js**: Installed in your environment (Cloud Shell recommended).
- **Permissions**: BigQuery Admin and Dataform Editor roles on your GCP project.

---

## 2. Local Setup & Compilation

### Initialize the environment
If you are working in a new terminal session, navigate to the project root:
```bash
cd clinical_trials_dataform
```

### Compile the project
Compilation checks for syntax errors, missing dependencies, and resolves the directed acyclic graph (DAG).
```bash
npx @dataform/cli compile
```
*Note: If you see "Compiled successfully," your code is logically sound and ready to run.*

---

## 3. Execution (Populating BigQuery)

To run the pipelines and materialize the tables in BigQuery, follow these steps:

### Configure Credentials
Dataform requires a `.df-credentials.json` file in the root directory to authenticate with BigQuery. Create it with the following content:
```json
{
  "projectId": "meridian-dev-455515",
  "location": "us"
}
```

### Run the pipelines
Execute all actions in the project. This will create/update the 10 tables in your `joe_demo_test` dataset.
```bash
npx @dataform/cli run
```

### Run with Assertions
To verify data quality during execution (e.g., non-null checks):
```bash
npx @dataform/cli run --include-assertions
```

---

## 4. Deploying on Google Cloud (Production)

To move from manual CLI execution to an automated, managed environment on GCP:

### Step 1: Create a Dataform Repository
1. Go to the **Dataform** page in the Google Cloud Console.
2. Click **Create Repository**.
3. Name it `clinical-trials-analytics` and select your region (`us-central1` or similar).

### Step 2: Connect to Git
1. Push this local code to a Git provider (e.g., GitHub, GitLab, or Cloud Source Repositories).
2. In the Dataform Console, click **Settings** > **Connect Git Repository**.
3. Link your Git repo to the Dataform Repository.

### Step 3: Configure Release Configurations
1. In the repository, go to **Release Configurations**.
2. Click **Create Release Configuration**.
3. Set the frequency (e.g., daily) to compile your code and prepare it for execution.

### Step 4: Create Workflow Configurations (Scheduling)
1. Go to **Workflow Configurations**.
2. Click **Create Workflow Configuration**.
3. Select your Release Configuration.
4. Schedule the execution (e.g., every morning at 6 AM) to keep your clinical trial insights up to date.

---

## 5. Development Retrospective & Best Practices

To ensure architectural stability and avoid common pitfalls discovered during development, follow these "Environment-Centric" rules:

- **Audit Before Authoring**: Run `bq show --format=json [table_name]` to map the physical schema. Relying on assumed names (e.g., `title`) causes execution failures.
- **Probe AI Resources**: Confirm that connections (e.g., `cloud_ai_resources`) and models are active in the target region before implementing `AI.EMBED` or `AI.GENERATE`.
- **Handle Vector Search Structural Limits**: `VECTOR_SEARCH` requires a materialized **table** and non-nested fields. Use a "Base Materialization" layer to flatten data before processing.
- **Profile for Semantic Filters**: Use `SELECT DISTINCT` on filter columns (like `Phase`) to identify all string variations (`Phase III`, `PHASE3`, etc.) and ensure 100% data capture.

---

## 6. Troubleshooting & Limitations

### Common Issues
- **Vector Search Failure**: Ensure `ClinicalTrialMasterData_flattened` is materialized as a `table` before running semantic search models.
- **Model Not Found**: Verify that the connection `meridian-dev-455515.us.cloud_ai_resources` exists and is accessible.
- **GQL Errors**: GQL is case-sensitive. Ensure labels like `TestsDrug` match exactly what is in your property graph.

### Monitoring
Check the **BigQuery Job History** in the Cloud Console to see detailed logs and bytes billed for each Dataform action.
