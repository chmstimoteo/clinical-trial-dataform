# Clinical Trial Dataform Rules

- GCP Project ID: `meridian-dev-455515`
- Target Dataset: `joe_demo_test`
- Write all new pipeline models to the `definitions/` directory.
- Model files must use `.sqlx` format and contain a valid `config` block.
- In semantic search models, the cosine distance between embedding vectors is defined as:

$$
\text{Cosine Distance} = 1 - \frac{\mathbf{u} \cdot \mathbf{v}}{\|\mathbf{u}\|_2 \|\mathbf{v}\|_2}
$$

Please ensure all generated equations match this KaTeX syntax.
