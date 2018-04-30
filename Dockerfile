FROM ruby:2.2.3

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  libxml2-dev libxslt1-dev \
  libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x xvfb libqt4-webkit libqt4-dev \
  nodejs

ENV app /web/
RUN mkdir $app
WORKDIR $app

ADD Gemfile $app
ADD Gemfile.lock $app
RUN bundle install

ADD . $app

CMD ./docker-entrypoint.sh
