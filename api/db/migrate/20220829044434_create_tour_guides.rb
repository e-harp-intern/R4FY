class CreateTourGuides < ActiveRecord::Migration[7.0]
  def change
    create_table :tour_guides do |t|
      t.references :tour, foreign_key: true
      t.references :guide, foreign_key: true
      t.boolean :achievement
      t.boolean :attend
      t.string :memo
      t.timestamps
    end
  end
end
