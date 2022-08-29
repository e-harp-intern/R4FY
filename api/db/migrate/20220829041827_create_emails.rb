class CreateEmails < ActiveRecord::Migration[7.0]
  def change
    create_table :emails do |t|
      t.references :tour
      t.references :guide
      t.datetime :sent_datetime
      t.text :body
      t.string :title
      t.timestamps
    end
  end
end
