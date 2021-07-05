# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_05_184412) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "projects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.boolean "active", default: true, null: false
    t.boolean "public", default: true, null: false
    t.text "description", default: "", null: false
    t.string "project_type", default: "", null: false
    t.string "repository", default: "", null: false
    t.index ["slug"], name: "index_projects_on_slug", unique: true
  end

  create_table "tasks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title", default: "", null: false
    t.string "slug", default: "", null: false
    t.text "description", default: "", null: false
    t.string "status", default: "", null: false
    t.string "task_type", default: "", null: false
    t.integer "project_index", null: false
    t.uuid "project_id"
    t.index ["project_id"], name: "index_tasks_on_project_id"
    t.index ["slug"], name: "index_tasks_on_slug", unique: true
  end

  add_foreign_key "tasks", "projects"
end
