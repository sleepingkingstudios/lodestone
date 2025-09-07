# frozen_string_literal: true

module Lodestone::Boards::View
  # Component rendered when the Board does not contain any tasks.
  class Show::EmptyMessage < Librum::Components::Bulma::Base
    dependency :routes

    option :project

    private

    def message
      if project
        "There are no matching tasks for project #{project.name}."
      else
        'There are no matching tasks.'
      end
    end

    def new_link_path
      return routes.new_project_task_path(project.slug) if project

      routes.new_task_path
    end

    def render_create_link
      component = components::Link.new(
        color: 'success',
        text:  'Create Task',
        url:   new_link_path
      )

      render(component)
    end
  end
end
