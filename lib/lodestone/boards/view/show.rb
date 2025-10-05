# frozen_string_literal: true

module Lodestone::Boards::View
  # View displaying the board for the current project, or the global board.
  class Show < Librum::Components::View
    STATUSES = [
      Task::Statuses::ICEBOX,
      Task::Statuses::TO_DO,
      Task::Statuses::IN_PROGRESS,
      Task::Statuses::DONE
    ].freeze
    private_constant :STATUSES

    dependency :routes

    # @return [Project, nil] the project returned by the controller, if any.
    def project
      @project ||= result.value&.[]('project')
    end

    # @return [Hash{String=>Array[Task]}] the tasks returned by the controller,
    #   grouped by the task status.
    def tasks
      @tasks ||= result.value&.fetch('tasks', {})
    end

    private

    def actions
      [
        {
          button: true,
          icon:   'plus',
          text:   'Create Task',
          url:    new_task_path
        }
      ]
    end

    def columns
      STATUSES.map do |status|
        Lodestone::Boards::View::Show::Column.new(
          status:,
          tasks:  tasks&.fetch(status, [])
        )
      end
    end

    def empty_tasks?
      return true if tasks.nil?

      tasks.each_value.all?(&:empty?)
    end

    def new_task_path
      return routes.new_project_task_path(project.slug) if project

      routes.new_task_path
    end

    def render_empty_message
      component = Lodestone::Boards::View::Show::EmptyMessage.new(project:)

      render(component)
    end

    def render_heading
      component = components::Heading.new(
        actions:,
        level:   1,
        text:    project&.name || 'All Tasks'
      )

      render(component)
    end

    def render_project_link
      return if project.blank?

      content_tag('p') do
        component = components::Link.new(
          color: 'link',
          icon:  'arrow-right',
          text:  'View Project',
          url:   "/projects/#{project['slug']}"
        )

        render(component)
      end
    end
  end
end
