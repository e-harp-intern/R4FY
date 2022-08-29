class CreateGuides < ActiveRecord::Migration[7.0]
  def change
    create_table :guides do |t|
      t.string :name
      t.string :email
      t.string :memo
      t.boolean :is_invalid
      t.timestamps
    end
    add_index :guides, [:email], unique: true
  end
end
