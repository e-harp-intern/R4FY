class ChangeColumnTours < ActiveRecord::Migration[7.0]
    def change
        change_column :tours, :schedule_input_deadline, :date
    end
end
