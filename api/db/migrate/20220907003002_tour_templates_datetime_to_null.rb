class TourTemplatesDatetimeToNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :tour_templates, :start_datetime, true
    change_column_null :tour_templates, :end_datetime, true
    change_column_null :tour_templates, :guide_num, true
  end
end
