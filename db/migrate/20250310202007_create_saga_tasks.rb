# frozen_string_literal: true

class CreateSagaTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :saga_tasks, id: :uuid do |t|
      t.timestamps

      t.references :saga, type: :uuid
      t.references :task, type: :uuid
    end
  end
end
