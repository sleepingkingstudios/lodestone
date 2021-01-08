# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :projects, id: :uuid do |t|
      t.timestamps

      t.string  :name,         null: false, default: ''
      t.string  :slug,         null: false, default: ''
      t.boolean :active,       null: false, default: true
      t.boolean :public,       null: false, default: true
      t.text    :description,  null: false, default: ''
      t.string  :project_type, null: false, default: ''
      t.string  :repository,   null: false, default: ''
    end

    add_index :projects, :slug, unique: true
  end
end
