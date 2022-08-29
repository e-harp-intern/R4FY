class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :admins do |t|
      t.string :name
      t.string :email
      t.string :password
      t.boolean :is_invalid
      t.timestamps
    end
    add_index :admins, [:email], unique: true

  end
end
