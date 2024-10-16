# frozen_string_literal: true

class Task < ApplicationRecord
  include SearchByAI::Model
end
