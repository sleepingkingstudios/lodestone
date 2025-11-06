# frozen_string_literal: true

require_relative 'config/environment'

load 'librum/iam/tasks.thor'

begin
  require 'sleeping_king_studios/tasks'

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

  load 'sleeping_king_studios/tasks/ci/tasks.thor'
  load 'sleeping_king_studios/tasks/file/tasks.thor'
rescue LoadError
  # Not defined in production environment.
end
