class CreateClientes < ActiveRecord::Migration[8.1]
  def change
    create_table :clientes do |t|
      t.string   :nombre,    null: false
      t.string   :correo,    null: false
      t.string   :telefono,  null: false
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :clientes, :correo,     unique: true
    add_index :clientes, :deleted_at
  end
end
