class CreatePasswordResetTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :password_reset_tokens do |t|
      t.references :admin, foreign_key: true
      t.string :token
      t.timestamps
    end
  end
end
