class CreateGuideSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :guide_schedules do |t|
      t.references :tour, foreign_key: true
      t.references :guide, foreign_key: true
      t.boolean :answered, :null => false, :default => false
      t.boolean :possible, :null => false, :default => false
      t.timestamps
    end
    change_column_null :guide_schedules, :tour_id, false
    change_column_null :guide_schedules, :guide_id, false
  end
end
