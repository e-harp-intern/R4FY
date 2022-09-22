class RemoveColumnTours < ActiveRecord::Migration[7.0]
    def change
        remove_column :tours, :remind_date, :date
        rename_column :tours, :sent_remind, :send_remind
    end
end
