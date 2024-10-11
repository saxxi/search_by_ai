module SearchByAI
  module Model
    extend ActiveSupport::Concern

    included do
      has_many :ai_embedding_contents, class_name: SearchByAI::AIEmbeddingContent.name, as: :source
      after_save :reindex_search_by_ai_content
    end

    def search_by_ai_content
      as_json
    end

    def reindex_search_by_ai_content
      content_data = search_by_ai_content
      embedding = generate_embedding(content_data)

      ai_embedding_content = ai_embedding_contents.find_or_initialize_by(source: self)
      ai_embedding_content.embedding = embedding
      ai_embedding_content.save!
    end

    def generate_embedding(content)
      response = Langchain::LLM::OpenAI.new(
        api_key: SearchByAI.configuration.api_key,
        default_options: { temperature: 0.7, chat_completion_model_name: "gpt-4o" }
      ).embed(text: content.to_json)
      response.raw_response["data"].map { |item| item["embedding"] }.first
    end

    class << self
      attr_accessor :configuration

      def configure
        self.configuration ||= Configuration.new
        yield(configuration) if block_given?
      end
    end

    module ClassMethods
      def search_with_ai_embedding(embedding)
        sanitized_embedding = Arel.sql("ARRAY[#{embedding.join(',')}]::vector")
        joins(:ai_embedding_contents)
          .where(Arel.sql("ai_embedding_contents.embedding <=> #{sanitized_embedding}"))
          .order(Arel.sql("ai_embedding_contents.embedding <=> #{sanitized_embedding}"))
      end

      def search_with_ai(text)
        # embedding = generate_embedding_from_text(text)
        embedding = [[123,32]]
        search_with_ai_embedding(embedding)
      end

      private

      def generate_embedding_from_text(text)
        response = Langchain::LLM::OpenAI.new(
          api_key: SearchByAI.configuration.api_key,
          default_options: { temperature: 0.7, chat_completion_model_name: "gpt-4o" }
        ).embed(text: text)
        response.raw_response["data"].map { |item| item["embedding"] }.first
      end
    end
  end
end
