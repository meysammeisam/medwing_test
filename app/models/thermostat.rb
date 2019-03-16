class Thermostat < ApplicationRecord
  has_many :readings

  validates :household_token, :location, presence: true, uniqueness: true
end
