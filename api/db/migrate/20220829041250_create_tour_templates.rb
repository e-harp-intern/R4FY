class CreateTourTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :tour_templates do |t|
      t.string :name, :null => false
      t.datetime :start_datetime, :null => false
      t.datetime :end_datetime, :null => false
      t.integer :guide_num, :null => false
      t.timestamps
    end
  end
end
