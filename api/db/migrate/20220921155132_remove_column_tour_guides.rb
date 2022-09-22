class RemoveColumnTourGuides < ActiveRecord::Migration[7.0]
    def change
        remove_column :tour_guides, :attend, :boolean
        remove_column :tour_guides, :memo, :string
    end
  end
