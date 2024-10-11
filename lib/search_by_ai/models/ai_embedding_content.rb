# frozen_string_literal: true

module SearchByAI
  class AIEmbeddingContent < ActiveRecord::Base
    self.table_name = "ai_embedding_contents"

    belongs_to :source, polymorphic: true
  end
end
