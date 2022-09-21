class TourColumnNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :tours, :schedule_input_deadline, true
  end
end
