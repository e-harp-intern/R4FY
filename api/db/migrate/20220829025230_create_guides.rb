class CreateGuides < ActiveRecord::Migration[7.0]
  def change
    create_table :guides do |t|
      t.string :name, :null => false
      t.string :email, :null => false
      t.string :memo, :null => false, :default => ''
      t.boolean :is_invalid, :null => false, :default => false
      t.timestamps
    end
    add_index :guides, [:email], unique: true
  end
end
