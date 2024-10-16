# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :organization_id, null: false, index: true
      t.string :name, null: false
      t.string :category, null: false
      t.text :description, null: false
      t.index %i[name category description], using: :gin

      t.timestamps
    end
  end
end
