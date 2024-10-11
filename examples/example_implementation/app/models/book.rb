# frozen_string_literal: true

class Book < ApplicationRecord
  include SearchByAI::Model
end
