# Clinical Trials: Gold-Standard Validation Queries

These queries serve as the "Truth Source" for the clinical trial analytics platform. They are executed independently of the Dataform pipelines to perform blind validation and schema alignment.

## 1. Search Intelligence (Vector Search)

### Query 1: Cancer Semantic Search
```sql
SELECT base.StudyTitle, distance 
FROM AI.SEARCH(TABLE `meridian-dev-455515.joe_demo_test.ClinicalTrialMasterData_embedded2`, 'StudyTitle', 'Cancer treated by MK-3475', top_k => 10)
```

### Query 2: Metabolic Semantic Search
```sql
SELECT base.StudyTitle, distance 
FROM AI.SEARCH(TABLE `meridian-dev-455515.joe_demo_test.ClinicalTrialMasterData_embedded2`, 'StudyTitle', 'Metabolic diseases', top_k => 10)
```

### Query 3: Immunotherapy Hybrid Search
```sql
SELECT base.StudyTitle 
FROM AI.SEARCH(TABLE `meridian-dev-455515.joe_demo_test.ClinicalTrialMasterData_embedded2`, 'StudyTitle', 'Cancer treated by MK-3475', mode => 'hybrid', top_k => 10)
```

### Query 4: AstraZeneca Chronic Disease Hybrid Search
```sql
SELECT base.study_name, base.sponsor, base.chunks, distance 
FROM VECTOR_SEARCH(TABLE `meridian-dev-455515.joe_demo_test.ClinicalTrialChunks`, 'embedding', 
     query_value => AI.EMBED('chronic disease studies by AstraZeneca', connection_id => 'meridian-dev-455515.us.cloud_ai_resources', endpoint => 'text-embedding-005').result, 
     lexical_search_columns => ['sponsor'], lexical_search_query_value => 'chronic disease studies by AstraZeneca', top_k => 10) 
ORDER BY distance ASC
```

## 2. Graph Traversal (GQL)

### Query 5: Bomedemstat Sponsor Relationships
```sql
SELECT DISTINCT sponsor_name, trial_title 
FROM GRAPH_TABLE(`meridian-dev-455515.joe_demo_test.clinical_trial_graph` 
  MATCH (t:Trial)-[:SponsoredBy]->(s:Sponsor), (t)-[:TestsDrug]->(d:Drug) 
  WHERE d.drug_name = 'Bomedemstat' 
  RETURN s.sponsor_name AS sponsor_name, t.StudyTitle AS trial_title)
```

### Query 6: Multi-Hop Repurposing
```sql
SELECT * FROM GRAPH_TABLE(`meridian-dev-455515.joe_demo_test.clinical_trial_graph` 
  MATCH (t:Trial)-[:TestsDrug]->(d:Drug)<-[:TestsDrug]-(other:Trial) 
  WHERE t.Phase = 'Phase 3' AND t.NCT_Number != other.NCT_Number 
  RETURN t.NCT_Number AS source_nct, t.StudyTitle AS source_trial, d.drug_name AS shared_drug, other.StudyTitle AS related_trial, other.Disease_Areas AS related_disease) 
LIMIT 10
```

## 3. Relational BI & Aggregations

### Query 7: Total Phase 3 Enrollment
```sql
SELECT SUM(Targeted_Enrollment) AS total_targeted_enrollment, COUNT(*) AS total_trials 
FROM `meridian-dev-455515.joe_demo_test.ClinicalTrialMasterData_embedded2` 
WHERE Phase LIKE '%Phase III%' OR Phase LIKE '%Phase 3%' OR Phase LIKE '%PHASE3%'
```

### Query 8: Top 10 Active Sponsors
```sql
SELECT Sponsor, COUNT(*) AS trial_count 
FROM `meridian-dev-455515.joe_demo_test.ClinicalTrialMasterData_embedded2` 
WHERE Trial_Status IN ('Active', 'Completed', 'Completed (Primary Phase)', 'Ongoing', 'Recruiting') 
GROUP BY Sponsor ORDER BY trial_count DESC LIMIT 10
```

## 4. Generative AI Synthesis

### Query 9: AstraZeneca Eligibility Extraction
```sql
SELECT Sponsor, StudyTitle, criteria_type, criteria_text 
FROM `meridian-dev-455515.joe_demo_test.ClinicalTrialMasterData_embedded2` 
WHERE Sponsor LIKE '%AstraZeneca%' AND StudyTitle IS NOT NULL LIMIT 5
```

### Query 10: AI Layman Comparison (Bomedemstat)
```sql
WITH relevant_trials AS (SELECT base.NCT_Number FROM AI.SEARCH(TABLE `meridian-dev-455515.joe_demo_test.ClinicalTrialMasterData_embedded2`, 'StudyTitle', 'Metabolic diseases', mode => 'hybrid', top_k => 10)), 
graph_data AS (SELECT * FROM GRAPH_TABLE(`meridian-dev-455515.joe_demo_test.clinical_trial_graph` MATCH (t:Trial)-[:TestsDrug]->(d:Drug)<-[:TestsDrug]-(other:Trial) WHERE t.Phase = 'Phase 3' RETURN t.NCT_Number AS t_nct, t.StudyTitle AS source_trial, d.drug_name AS drug, other.StudyTitle AS related_trial, other.NCT_Number AS other_nct, other.Disease_Areas AS related_disease)), 
raw_results AS (SELECT DISTINCT gd.source_trial, gd.drug, gd.related_trial, gd.related_disease FROM graph_data gd JOIN relevant_trials rt ON gd.t_nct = rt.NCT_Number WHERE gd.t_nct != gd.other_nct AND gd.drug = 'Bomedemstat') 
SELECT source_trial, drug, related_trial, AI.GENERATE(prompt => 'Analyze these two clinical trials testing the same drug (' || drug || '). Provide a pithy, one-sentence cross-indication laymans insight starting with "Based on the findings of these two studies...". Trial 1: ' || source_trial || ' | Trial 2: ' || related_trial, endpoint => 'gemini-2.5-flash', output_schema => 'summary STRING', connection_id => 'meridian-dev-455515.us.cloud_ai_resources').summary AS cross_trial_insight FROM raw_results LIMIT 5
```
