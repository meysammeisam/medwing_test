# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version 2.4.0

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
