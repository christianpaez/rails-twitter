FROM ruby:2.6.6
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y nodejs yarn
RUN mkdir /myapp bash
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
ENV BUNDLE_PATH=/gems \
    BUNDLE_BIN=/gems/bin \
    GEM_HOME=/gems
ENV PATH="${BUNDLE_BIN}:${PATH}"
RUN gem install rails bundler
RUN bundle install
RUN adduser myuser
USER myuser
CMD RAILS_ENV=production bundle exec rails db:migrate && \
    RAILS_ENV=production bundle exec rails s -b 0.0.0.0 -p ${PORT}