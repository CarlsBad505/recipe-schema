FROM ruby:2.6.5

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y nodejs yarn --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y default-mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update

COPY Gemfile /usr/src/app/

RUN bundle install

COPY . /usr/src/app

RUN yarn install --check-files
RUN rails db:create db:migrate db:seed

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
