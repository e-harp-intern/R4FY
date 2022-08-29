class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens do |t|
      t.references :tour, foreign_key: true
      t.references :guide, foreign_key: true
      t.string :token, :null => false
      t.timestamps
    end
  end
end
