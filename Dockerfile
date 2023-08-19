FROM ruby:3.1.3
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y nodejs yarn postgresql-client shared-mime-info
RUN yarn install
RUN mkdir /paivalima
WORKDIR /paivalima
COPY Gemfile /paivalima/Gemfile
COPY Gemfile.lock /paivalima/Gemfile.lock
RUN bundle install
COPY . /paivalima

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# # Start the main process.
# CMD ["rails", "server", "-b", "0.0.0.0"]
