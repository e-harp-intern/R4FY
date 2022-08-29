class CreateEmails < ActiveRecord::Migration[7.0]
  def change
    create_table :emails do |t|
      t.references :tour, :null => false
      t.references :guide, :null => false
      t.datetime :sent_datetime, :null => false
      t.text :body, :null => false
      t.string :title, :null => false
      t.timestamps
    end
  end
end
