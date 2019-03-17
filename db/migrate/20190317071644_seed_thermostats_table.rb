class SeedThermostatsTable < ActiveRecord::Migration[5.1]
  def change
    Thermostat.create(
      [
        { id: 1, household_token: 'asdasd1', location: 'street A' },
        { id: 2, household_token: 'asdasd2', location: 'street B' },
        { id: 3, household_token: 'asdasd3', location: 'street C' },
        { id: 4, household_token: 'asdasd4', location: 'street D' },
        { id: 5, household_token: 'asdasd5', location: 'street E' }
      ]
    )
  end
end
