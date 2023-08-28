FROM ruby:3.1.2

RUN apt-get update -qq && \
    apt-get install -y build-essential \
    libpq-dev \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN printf 'Package: nodejs\nPin: origin deb.nodesource.com\nPin-Priority: 1001' > /etc/apt/preferences.d/nodesource \
  && curl -sL https://deb.nodesource.com/setup_18.x | bash -\
  && apt-get update -qq && apt-get install -qq --no-install-recommends \
    nodejs \
  && apt-get upgrade -qq \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*\
  && npm install -g yarn@1

RUN mkdir /app
ENV APP_ROOT /app
WORKDIR $APP_ROOT

ADD ./Gemfile $APP_ROOT/Gemfile
ADD ./Gemfile.lock $APP_ROOT/Gemfile.lock

RUN bundle install
