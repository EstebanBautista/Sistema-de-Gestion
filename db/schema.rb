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

ActiveRecord::Schema[8.1].define(version: 2026_05_14_160549) do
  create_table "clientes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "correo", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "nombre", null: false
    t.string "telefono", null: false
    t.datetime "updated_at", null: false
    t.index ["correo"], name: "index_clientes_on_correo", unique: true
    t.index ["deleted_at"], name: "index_clientes_on_deleted_at"
  end

  create_table "ordenes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "cliente_id", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.text "descripcion", null: false
    t.integer "estado", default: 0, null: false
    t.string "folio", null: false
    t.string "titulo", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_ordenes_on_cliente_id"
    t.index ["estado", "deleted_at"], name: "index_ordenes_on_estado_and_deleted_at"
    t.index ["folio"], name: "index_ordenes_on_folio", unique: true
  end

  add_foreign_key "ordenes", "clientes"
end
