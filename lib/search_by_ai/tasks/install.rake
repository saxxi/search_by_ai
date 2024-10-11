# frozen_string_literal: true

namespace :search_by_ai do
  desc "Install search_by_ai dependencies"
  task install: :environment do
    Rake::Task["search_by_ai:create_table"].invoke
    puts "search_by_ai dependencies installed."
  end

  desc "Create a new table"
  task create_table: :environment do
    migration_content = <<~MIGRATION
      class CreateAIEmbeddingContents < ActiveRecord::Migration[7.0]
        def up
          enable_extension 'vector'

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
    MIGRATION

    migration_file = File.join("db/migrate",
                               "#{Time.now.strftime("%Y%m%d%H%M%S").to_i}_create_ai_embedding_contents.rb")
    File.write(migration_file, migration_content)

    puts "Table 'ai_vector_contents' created."
  end
end
