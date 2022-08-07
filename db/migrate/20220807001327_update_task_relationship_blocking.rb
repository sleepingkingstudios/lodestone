# frozen_string_literal: true

class UpdateTaskRelationshipBlocking < ActiveRecord::Migration[7.0]
  def change
    change_table :task_relationships, bulk: true do |t|
      t.rename :blocking, :blocks_start

      t.boolean :blocks_complete, null: false, default: false
    end
  end
end
