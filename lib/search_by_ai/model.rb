module SearchByAI
  module Model
    extend ActiveSupport::Concern

    included do
      has_many :ai_embedding_contents, class_name: SearchByAI::AIEmbeddingContent.name, as: :source
      after_commit :reindex_search_by_ai_content
    end

    # You can override this method in your model to define the content to be embedded
    def search_by_ai_content
      as_json
    end

    def reindex_search_by_ai_content
      content_data = search_by_ai_content
      embedding = self.class.fetch_short_text_embedding(content_data)
      ai_embedding_content = ai_embedding_contents.find_or_initialize_by(source: self)
      ai_embedding_content.assign_attributes(content: content_data, embedding:)
      ai_embedding_content.save!
    end

    module ClassMethods
      def search_with_embedding(embedding)
        value = ActiveRecord::Base.connection.quote("[#{embedding.join(',')}]")
        joins(:ai_embedding_contents)
          .select(Arel.sql("#{self.table_name}.*, (ai_embedding_contents.embedding <-> #{value}) AS distance"))
          .order(Arel.sql("ai_embedding_contents.embedding <=> #{value}"))
          # .where(Arel.sql("ai_embedding_contents.embedding <=> #{value} < 0.5"))
      end

      def search_with(text)
        embedding = Rails.cache.fetch("embeds/#{text.hash}", expires_in: 10.minutes) do
          fetch_short_text_embedding(text)
        end

        search_with_embedding(embedding)
      end

      def fetch_short_text_embedding(content)
        SearchByAI::FetchEmbeddings.new.call(content)
      end
    end
  end
end
