class Thermostat < ApplicationRecord
  has_many :readings, dependent: :destroy

  validates :household_token, :location, presence: true, uniqueness: true
end
