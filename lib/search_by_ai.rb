# frozen_string_literal: true

require "rake"
require "pgvector"
require "openai"
require "langchain"

require_relative "search_by_ai/version"
require_relative "search_by_ai/configuration"
require_relative "search_by_ai/model"
require_relative "search_by_ai/models/ai_embedding_content"

Dir[File.join(__dir__, "search_by_ai/tasks/**/*.rake").sub("(rdbg)/", "")].each { |file| load file }

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "AI"
end

module SearchByAI
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end
  end
end
