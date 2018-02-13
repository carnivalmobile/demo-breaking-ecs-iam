FROM ruby:2.3.4-alpine

# Packages required by bundler since we use some gems from git repos
RUN apk add --update git openssh tzdata file imagemagick=6.9.5.9-r1

ADD . /demo
WORKDIR /demo

RUN bundle install --deployment

CMD ["bundle", "exec", "demo.rb"]

