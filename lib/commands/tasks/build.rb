# frozen_string_literal: true

require 'cuprum'

require 'commands/projects/next_index'
require 'commands/tasks'

module Commands::Tasks
  # Builds a task model instance with the given project and attributes.
  class Build < Cuprum::Command
    private

    def next_project_index(project)
      step { Commands::Projects::NextIndex.new(project: project).call }
    end

    def process(project:, attributes: {})
      project_index = next_project_index(project)
      attributes    = attributes.merge(
        project:       project,
        project_index: project_index,
        slug:          "#{project.slug}-#{project_index}"
      )

      Task.new(attributes)
    end
  end
end
