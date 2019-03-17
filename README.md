# MedWing coding challenge

## What this web application does

Coding challenge was about implementing a web service to handle a heavy loaded service.
It has a Json API with 3 endpoints:
* `POST api/v1/readings/` to push new readings
* `GET  api/v1/readings/[:id]` to fetch readings
* `GET  api/v1/thermostat/stats` to fetch a specific thermostat's average values of all the time

All of the requests must be authenticated using a custom HTTP request header called `HouseholdToken`.
The header must provide a valid household token of a thermostat.

The challenge asks to save data on DB using a background job to provide HTTP responses as soon as possible.
For that, I implemented an ***OnAir*** data management service using redis. On first request for each thermostat, the manager seed the redis, and after that for next requests of the same thermostat it just updates the OnAir data.

Another thing that hadn't mentioned on the challeng description, was the data inconsistency issue that would happen. Saving data on redis, and then from redis into DB, would make data inconsistency issue because of various race conditions on seq_number and id setting.
To prevent it I used a DLM(Distributed Lock Manager) that I had implemented and used before on different projects to solve similar issues.

The average response time(rails response time) of the creation request is less than 8ms.
As a side note, Siatra would have been a better tool for this implementation.

About tests, actually it was my first time writing tests in RSpec.therefore, It's not my best as I've always written tests using Minitests.
And unfortunately, because of time shortage, I couldn't add more tests for models and libs.

There're 3 DB migrations, 2 for creating the `readings` and `thermostats` tables, and one for seeding the thermostat table.

A POSTMAN collection is also created to make using the API endpoints more convenient. It could be reached at:
https://www.getpostman.com/collections/6a839d618364605f9111


To run and use this app as I did, you need to have docker and docker-compose on your machine:
* Docker version 18.09.3
* docker-compose version 1.16.1

#### 1 Prepare DB
  * Create User

    ```bash
    docker-compose run app psql -h postgres -p 5432 -c "CREATE USER medwing WITH PASSWORD '123456';" postgres -U postgres
    docker-compose run app psql -h postgres -p 5432 -c "ALTER USER medwing WITH SUPERUSER;" postgres -U postgres
    ```

  * Create DBs

    ```bash
    docker-compose run app psql -h postgres -p 5432 -c "CREATE DATABASE medwing_dev;" postgres -U postgres
    docker-compose run app psql -h postgres -p 5432 -c "CREATE DATABASE medwing_test;" postgres -U postgres
    ```
  * Migrate

    ```bash
    docker-compose run app rails db:migrate RAILS_ENV=test
    docker-compose run app rails db:migrate
    ```

#### 2 Run server
This command runs puma web server, sidekiq, postgresql and redis:

`docker-compose up`

#### 3 Run rails console
`docker-compose run app rails c`

#### 4 Run rspec test
`docker-compose run app bundle exec rspec`

#### 5 Run the benchmark
First make sure you have started web server, then run:

`docker-compose run app ruby benchmark.rb`

On my machine the average response time of 1000 requests is 7.8ms:
```
Average response time pf 1000 requests:
"Push Readings: 7.8ms"
```
