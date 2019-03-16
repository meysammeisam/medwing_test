class Reading < ApplicationRecord
  belongs_to :thermostat

  validates :thermostat, :temperature, :humidity, :battery_charge, :seq_number, presence: true
  validates :temperature, :humidity, :battery_charge, numericality: true
  validates :seq_number, numericality: { greater_than_or_equal_to: 1 }, uniqueness: { scope: :thermostat_id }
end
