# frozen_string_literal: true

require 'sleeping_king_studios/tasks'

require_relative 'config/environment'

SleepingKingStudios::Tasks.configure do |config|
  config.ci do |ci|
    ci.rspec.update format: 'progress'

    ci.steps = %i[rspec rubocop simplecov]
  end

  config.file do |file|
    file.template_paths =
      [
        '../sleeping_king_studios-templates/lib',
        file.class.default_template_path
      ]
  end
end

load 'librum/iam/tasks.thor'
load 'sleeping_king_studios/tasks/ci/tasks.thor'
load 'sleeping_king_studios/tasks/file/tasks.thor'
