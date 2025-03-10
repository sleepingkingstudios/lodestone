# frozen_string_literal: true

class CreateSagas < ActiveRecord::Migration[8.0]
  def change
    create_table :sagas, id: :uuid do |t|
      t.string :name,   default: '', null: false
      t.string :slug,   default: '', null: false
      t.string :status, default: '', null: false

      t.timestamps
    end

    add_index :sagas, :name, unique: true
    add_index :sagas, :slug, unique: true
  end
end
