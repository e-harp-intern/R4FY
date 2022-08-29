class CreateTourGuides < ActiveRecord::Migration[7.0]
  def change
    create_table :tour_guides do |t|
      t.references :tour, foreign_key: true
      t.references :guide, foreign_key: true
      t.boolean :achievement, :null => false, :default => false
      t.boolean :attend, :null => false, :default => false
      t.string :memo, :null => false, :default => ''
      t.timestamps
    end
  end
end
