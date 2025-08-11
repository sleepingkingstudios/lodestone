# frozen_string_literal: true

require 'cuprum/rails/command'

module Boards::Commands
  # Command for displaying a board.
  class Show < Cuprum::Rails::Command
    validate :project_id

    private

    def find_project(project_id)
      return nil if project_id.blank?

      Librum::Core::Models::Queries::FindOne
        .new(collection: projects_collection)
        .call(value: project_id)
    end

    def find_and_group_tasks(project_id)
      scope = project_id ? { project_id: } : {}
      tasks = step do
        tasks_collection.find_matching.call(
          order: { updated_at: :desc },
          where: scope
        )
      end

      tasks.group_by(&:status)
    end

    def process(project_id: nil, **rest)
      super()

      project = step { find_project(project_id) }
      tasks   = step { find_and_group_tasks(project&.id) }

      { 'project' => project, 'tasks' => tasks }
    end

    def projects_collection
      repository.find_or_create(entity_class: Project)
    end

    def tasks_collection
      repository.find_or_create(entity_class: Task)
    end

    def validate_project_id(project_id, as: 'project_id')
      return if project_id.nil?
      return if project_id.is_a?(String) && !project_id.empty?

      "#{as} must be a valid id or slug"
    end
  end
end
