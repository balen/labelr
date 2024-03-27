#!/usr/bin/env sh
# inspired by the start script  from Matthew's wellington code

export NODE_ENV=${RAILS_ENV}

# Development environment setup runs when RAILS_ENV is not set
if [[ -z $RAILS_ENV ]] || [[ $RAILS_ENV = "development" ]]; then
  gem install bundler:2.2.4
  bin/bundle install --quiet
  bin/vite install
  
  bin/rake assets:precompile
else
  until psql -Atx "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$DB_HOST/$DB_NAME" -c 'select current_date'; do
    echo "waiting for postgres..."
    sleep 5
  done
fi

bundle exec sidekiq