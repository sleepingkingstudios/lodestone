# frozen_string_literal: true

class CreateTaskRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :task_relationships, id: :uuid do |t|
      t.timestamps

      t.string  :relationship_type, null: false, default: ''
      t.boolean :blocking,          null: false, default: false
    end

    add_reference :task_relationships,
      :source_task,
      foreign_key: { to_table: :tasks },
      type:        :uuid

    add_reference :task_relationships,
      :target_task,
      foreign_key: { to_table: :tasks },
      type:        :uuid
  end
end
