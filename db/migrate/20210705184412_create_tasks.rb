# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks, id: :uuid do |t|
      t.timestamps

      t.string  :title,         null: false, default: ''
      t.string  :slug,          null: false, default: ''
      t.text    :description,   null: false, default: ''
      t.string  :status,        null: false, default: ''
      t.string  :task_type,     null: false, default: ''
      t.integer :project_index, null: false
    end

    add_index :tasks, :slug, unique: true

    add_reference :tasks,
      :project,
      foreign_key: true,
      type:        :uuid
  end
end
