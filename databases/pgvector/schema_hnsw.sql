-- Enable pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Table definition with relational metadata and embedding vector
CREATE TABLE document_chunks (
    id BIGSERIAL PRIMARY KEY,
    organization_id UUID NOT NULL,
    document_id UUID NOT NULL,
    content TEXT NOT NULL,
    is_archived BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    embedding vector(1536) NOT NULL
);

-- Build high-concurrency HNSW index with Cosine Distance (<=>)
CREATE INDEX ON document_chunks 
USING hnsw (embedding vector_cosine_ops)
WITH (m = 16, ef_construction = 64);

-- Example Hybrid Query (filtering tenant and semantic cosine similarity)
SELECT 
    id,
    content,
    1 - (embedding <=> '[0.012, -0.024, 0.089]'::vector) AS similarity_score
FROM document_chunks
WHERE organization_id = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'
  AND is_archived = FALSE
ORDER BY embedding <=> '[0.012, -0.024, 0.089]'::vector
LIMIT 5;
