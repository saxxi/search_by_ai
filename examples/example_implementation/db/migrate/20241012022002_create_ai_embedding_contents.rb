# frozen_string_literal: true

class CreateAIEmbeddingContents < ActiveRecord::Migration[7.0]
  def up
    enable_extension 'vector'

    create_table :ai_embedding_contents, force: true do |t|
      t.references :source, polymorphic: true, index: true
      t.string :content, null: false
      t.vector :embedding, null: false, limit: 1536
      t.timestamps
    end

    execute <<-SQL
      CREATE INDEX ai_embedding_contents_embedding_idx
      ON ai_embedding_contents
      USING hnsw (embedding vector_cosine_ops);
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX IF EXISTS ai_embedding_contents_embedding_idx;
    SQL

    drop_table :ai_embedding_contents
  end
end
