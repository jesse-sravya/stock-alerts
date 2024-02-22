ARG RUBY_VERSION=3.0.0
FROM ruby:$RUBY_VERSION

# Install libvips for Active Storage preview support
RUN apt-get update -qq && \
    apt-get install -y build-essential libvips && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man
RUN apt-get update && apt-get -y install cron

# Rails app lives here
WORKDIR /rails
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
COPY config/schedule.rb /myapp/config/schedule.rb
RUN bundle install
RUN rails db:migrate
RUN rails db:seed
RUN bundle exec whenever --update-crontab
CMD ["rails", "server"]
# TODO: run with gunicorn or puma