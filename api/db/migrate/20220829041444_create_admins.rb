class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :admins do |t|
      t.string :name, :null => false
      t.string :email, :null => false
      t.string :password_digest, :null => false
      t.boolean :is_invalid, :null => false, :default => false
      t.timestamps
    end
    add_index :admins, [:email], unique: true

  end
end
