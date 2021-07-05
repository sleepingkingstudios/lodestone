# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'rails', '~> 6.1.1'

gem 'pg', '~> 1.1' # Use postgresql as the database for Active Record

# Use Puma as the app server
gem 'puma', '~> 5.0'

# Assets
gem 'sass-rails', '>= 6' # Use SCSS for stylesheets
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'

gem 'bcrypt', '~> 3.1.7'

gem 'sleeping_king_studios-tools', '~> 1.0'

group :development, :test do
  gem 'annotate', '~> 3.1'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.1'
  gem 'thor', '~> 1.0'

  gem 'sleeping_king_studios-tasks',
    git: 'https://github.com/sleepingkingstudios/sleeping_king_studios-tasks'
end

group :development do
  gem 'listen', '~> 3.3'
end

group :test do
  gem 'rspec', '~> 3.10'
  gem 'rspec-rails', '~> 4.0'
  gem 'rspec-sleeping_king_studios', '~> 2.5'
  gem 'rubocop', '~> 1.8.0'
  gem 'rubocop-rails', '~> 2.9.1'
  gem 'rubocop-rspec', '~> 2.1.0'
  gem 'simplecov', '~> 0.21'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
