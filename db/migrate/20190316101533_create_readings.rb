class CreateReadings < ActiveRecord::Migration[5.1]
  def change
    create_table :readings do |t|
      t.references :thermostat
      t.integer :seq_number
      t.float :temperature
      t.float :humidity
      t.float :battery_charge

      t.timestamps
    end

    add_index :readings, %i[seq_number thermostat_id], unique: true
  end
end
