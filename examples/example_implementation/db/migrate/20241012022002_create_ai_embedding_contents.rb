# frozen_string_literal: true

class CreateAIEmbeddingContents < ActiveRecord::Migration[7.0]
  def up
    enable_extension "vector"

    create_table :ai_embedding_contents, force: true do |t|
      t.references :source, polymorphic: true, index: true
      t.vector :embedding, null: false, limit: 1536
      t.timestamps
    end
  end

  def down
    drop_table :ai_embedding_contents
  end
end
