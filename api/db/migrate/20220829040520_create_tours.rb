class CreateTours < ActiveRecord::Migration[7.0]
  def change
    create_table :tours do |t|
      t.string :name
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.integer :adalt_num
      t.integer :child_num
      t.integer :guide_num
      t.integer :tour_state_code
      t.datetime :schedule_input_deadline
      t.date :remind_date
      t.boolean :sent_remind
      t.string :memo
      t.timestamps
    end
  end
end
