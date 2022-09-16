class RenameDatetimeColumnToTimeTemplates < ActiveRecord::Migration[7.0]
    def change
      rename_column :tour_templates, :start_datetime, :start_time
      rename_column :tour_templates, :end_datetime, :end_time

      change_column :tour_templates, :start_time, :time
      change_column :tour_templates, :end_time, :time
    end
  end
