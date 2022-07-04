# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.4'

gem 'rails', '~> 7.0.0'

gem 'pg', '~> 1.1' # Use postgresql as the database for Active Record

# Use Puma as the app server
gem 'puma', '~> 5.0'

# Assets
gem 'sass-rails', '>= 6' # Use SCSS for stylesheets
gem 'sprockets-rails', require: 'sprockets/railtie'

gem 'bcrypt', '~> 3.1.7'

gem 'commonmarker',                '~> 0.23'
gem 'sleeping_king_studios-tools', '~> 1.0'

gem 'cuprum',
  branch: 'main',
  git:    'https://github.com/sleepingkingstudios/cuprum'
gem 'cuprum-collections',
  branch: 'main',
  git:    'https://github.com/sleepingkingstudios/cuprum-collections'
gem 'cuprum-rails',
  branch: 'main',
  git:    'https://github.com/sleepingkingstudios/cuprum-rails'

group :development, :test do
  gem 'annotate',
    group: :development,
    git:   'https://github.com/sleepingkingstudios/annotate_models'
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
  gem 'rspec-rails', '~> 5.0'
  gem 'rspec-sleeping_king_studios', '~> 2.7'
  gem 'rubocop', '~> 1.26'
  gem 'rubocop-rails', '~> 2.14'
  gem 'rubocop-rspec', '~> 2.9'
  gem 'simplecov', '~> 0.21'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
