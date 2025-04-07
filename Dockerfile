# Use official Ruby base image
FROM ruby:3.1

# Install OS dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn \
  postgresql-client \
  git

# Set working directory
WORKDIR /usr/src/app

# Copy and install Ruby dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy and install JS dependencies
COPY package.json yarn.lock ./
RUN yarn install
RUN yarn add sass

# Copy the rest of the application code
COPY . .

# Precompile assets (optional in production builds)
RUN RAILS_ENV=production bundle exec rake assets:precompile

# Default command (can be overridden in Compose)
CMD ["bash"]
