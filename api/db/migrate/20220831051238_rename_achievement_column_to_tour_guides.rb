class RenameAchievementColumnToTourGuides < ActiveRecord::Migration[7.0]
  def change
    rename_column :tour_guides, :achievement, :achievements_entered
  end
end
