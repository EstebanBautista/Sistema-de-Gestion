class CreateOrdenes < ActiveRecord::Migration[8.1]
  def change
    create_table :ordenes do |t|
      t.string   :folio,       null: false
      t.string   :titulo,      null: false
      t.text     :descripcion, null: false
      t.integer  :estado,      null: false, default: 0
      t.references :cliente,   null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :ordenes, :folio,                  unique: true
    add_index :ordenes, [:estado, :deleted_at]
  end
end
