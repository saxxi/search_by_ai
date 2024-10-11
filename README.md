# SearchByAI

Basic demonstration of gem to add vector embedding search to any model.

## Installation

1. Add `search_by_ai` gem

2. Launch the installer

    ```bash
    rake search_by_ai:install
    # creates db/[timestamp]_create_ai_embedding_contents.rb
    rake db:migrate
    ```

2. Set your initializer

    ```ruby
    # config/initializers/search_by_ai.rb
    SearchByAI.configure do |config|
      config.api_key = ENV["OPENAI_SECRET_KEY"]
    end
    ```

2. Add it to your model

    ```ruby
    # app/models/book.rb
    class Book < ApplicationRecord
      include SearchByAI::Model
    end
    ```


## Usage

### Basic usage

```ruby
# bundle exec rails c
Book.all.map(&:reindex_search_by_ai_content) # Calls OpenAI
books = Book.where(...).search_with_ai('best scientific novels')
```

### Customize content

You can ovveride `#search_by_ai_content` method (defaults to `as_json` if not implemented):

```ruby
class Book < ApplicationRecord
  include SearchByAI::Model

  private

  def search_by_ai_content
    {
      name:,
      description:,
      book_comments: book_comments.map do |bc|
        {
          comment: bc.comment,
        }
      end,
    }
  end
end
```

## Full Example

Look in examples/example_implementation for a full example.

Files Overview:

```
  /examples/example_implementation
    /config/initializers
      - search_by_ai.rb
    /app/models
      - book.rb
    /db/migrate
      - [...]_create_books.rb
      - [...]_create_ai_embedding_contents.rb
```

### Notes

- The models are stored in `SearchByAI::AIEmbeddingContent` (ActiveRecord class)
