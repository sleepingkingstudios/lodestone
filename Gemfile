# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.2'

gem 'bcrypt', '~> 3.1.7'
gem 'pg', '~> 1.5' # Use postgresql as the database for Active Record
gem 'puma', '~> 6.4', '>= 6.4.3'
gem 'rails', '~> 8.0.1'

# Engines
gem 'librum-core',
  branch: 'main',
  git:    'https://github.com/sleepingkingstudios/librum-core'
gem 'librum-iam',
  branch: 'main',
  git:    'https://github.com/sleepingkingstudios/librum-iam'

# Assets
gem 'commonmarker', '~> 0.23'
gem 'importmap-rails', '~> 2.1'
gem 'propshaft', '~> 1.1'
gem 'stimulus-rails', '~> 1.3'
gem 'turbo-rails', '~> 2.0'

# Commands
gem 'cuprum',
  branch: 'main',
  git:    'https://github.com/sleepingkingstudios/cuprum'
gem 'cuprum-collections',
  branch: 'main',
  git:    'https://github.com/sleepingkingstudios/cuprum-collections'
gem 'cuprum-rails',
  branch: 'main',
  git:    'https://github.com/sleepingkingstudios/cuprum-rails'
gem 'sleeping_king_studios-tools',
  branch: 'main',
  git:    'https://github.com/sleepingkingstudios/sleeping_king_studios-tools'
gem 'stannum',
  branch: 'main',
  git:    'https://github.com/sleepingkingstudios/stannum'

group :development, :test do
  gem 'annotaterb', '~> 4.14'

  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.4'
  gem 'thor', '~> 1.0'

  gem 'sleeping_king_studios-tasks',
    git: 'https://github.com/sleepingkingstudios/sleeping_king_studios-tasks'
end

group :development do
  gem 'listen', '~> 3.3'
end

group :test do
  gem 'rspec', '~> 3.13'
  gem 'rspec-rails', '~> 7.1'
  gem 'rspec-sleeping_king_studios',
    branch: 'main',
    git:    'https://github.com/sleepingkingstudios/rspec-sleeping_king_studios'
  gem 'rubocop', '~> 1.71'
  gem 'rubocop-factory_bot', '~> 2.26'
  gem 'rubocop-rails', '~> 2.29'
  gem 'rubocop-rspec', '~> 3.4'
  gem 'rubocop-rspec_rails', '~> 2.30'
  gem 'simplecov', '~> 0.21'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
