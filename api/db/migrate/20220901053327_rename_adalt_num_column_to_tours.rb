class RenameAdaltNumColumnToTours < ActiveRecord::Migration[7.0]
  def change
    rename_column :tours, :adalt_num, :adult_num
  end
end
