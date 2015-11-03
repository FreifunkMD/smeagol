FROM ruby
MAINTAINER Andreas Pfohl <mail@apfohl.com>

RUN apt-get update && apt-get install -y libicu-dev

ENV RACK_ENV production
ENV APP_HOME /smeagol
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
ADD . $APP_HOME/

RUN bundle install --deployment

EXPOSE 3131

ENTRYPOINT ["./smeagol"]
