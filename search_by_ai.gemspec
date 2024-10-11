# frozen_string_literal: true

require_relative "lib/search_by_ai/version"

Gem::Specification.new do |spec|
  spec.name = "search_by_ai"
  spec.version = SearchByAI::VERSION
  spec.authors = ["Adit Saxena"]
  spec.email = ["a.saxena.email@gmail.com"]

  spec.summary = "Allows PG vector searches on your documents"
  spec.description = "Include in your models, index their content and launch embedding-based searches"
  spec.homepage = "https://github.com/saxxi/search_by_ai"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/saxxi/search_by_ai"
  spec.metadata["changelog_uri"] = "https://github.com/saxxi/search_by_ai/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord"
  spec.add_dependency "langchainrb"
  spec.add_dependency "pg"
  spec.add_dependency "pgvector"
  spec.add_dependency "ruby-openai"
  spec.add_runtime_dependency "rake"
end
