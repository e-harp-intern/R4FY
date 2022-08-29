class CreateTourTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :tour_templates do |t|
      t.string :name
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.integer :guide_num
      t.timestamps
    end
  end
end
