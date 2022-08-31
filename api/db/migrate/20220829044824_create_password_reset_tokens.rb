class CreatePasswordResetTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :password_reset_tokens do |t|
      t.references :admin, foreign_key: true
      t.string :token, :null => false
      t.timestamps
    end
    change_column_null :password_reset_tokens, :admin_id, false
  end
end
