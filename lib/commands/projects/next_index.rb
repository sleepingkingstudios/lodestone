# frozen_string_literal: true

require 'cuprum'

require 'commands/projects'

module Commands::Projects
  # Determines the next index for a project's tasks.
  class NextIndex < Cuprum::Command
    def initialize(project:)
      super()

      @project = project
    end

    attr_reader :project

    private

    def process
      last_task = project.tasks.order(project_index: :desc).limit(1).first

      (last_task&.project_index || -1) + 1
    end
  end
end
