FROM ruby:2.4.0

ENV APP_HOME /home/medwing
WORKDIR $APP_HOME

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/postgres.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  libpq-dev postgresql-client-common postgresql-client-9.6

COPY Gemfile* ./

RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . .

EXPOSE 3000

# ENTRYPOINT ["bundle", "exec"]
# CMD ["rails s -p 3000"]
# Start the main process.
RUN bundle env
RUN bundle -v
RUN bundler -v
CMD ["rails", "server", "-b", "0.0.0.0"]
