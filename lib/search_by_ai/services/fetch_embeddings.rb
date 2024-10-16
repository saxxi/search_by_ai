# frozen_string_literal: true

module SearchByAI
  class FetchEmbeddings
    def initialize(api_key: ENV.fetch('OPENAI_SECRET_KEY'), model: 'text-embedding-3-small') # or text-embedding-ada-002
      @api_key = api_key
      @model = model
    end

    def call(content)
      fetch_embeddings(content)
    end

    private

    attr_reader :api_key, :model

    def fetch_embeddings(input)
      url = 'https://api.openai.com/v1/embeddings'
      headers = {
        'Authorization' => "Bearer #{api_key}",
        'Content-Type' => 'application/json'
      }
      data = { input: input.to_json, model: }
      response = Net::HTTP.post(URI(url), data.to_json, headers)
      raise "Failed to fetch embeddings: #{response.body}" unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body)['data']&.pick('embedding')
    end
  end
end
