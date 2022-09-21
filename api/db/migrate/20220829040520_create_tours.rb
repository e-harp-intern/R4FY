class CreateTours < ActiveRecord::Migration[7.0]
  def change
    create_table :tours do |t|
      t.string :name, :null => false
      t.datetime :start_datetime, :null => false
      t.datetime :end_datetime, :null => false
      t.integer :adalt_num, :null => false
      t.integer :child_num, :null => false
      t.integer :guide_num, :null => false
      t.integer :tour_state_code, :null => false, :default => 1
      t.datetime :schedule_input_deadline, :null => false
      t.date :send_remind, :null => false
      t.boolean :sent_remind, :null => false
      t.string :memo, :null => false, :default => ''
      t.timestamps
    end
  end
end
