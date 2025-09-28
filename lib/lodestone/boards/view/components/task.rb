# frozen_string_literal: true

module Lodestone::Boards::View::Components
  # Component rendering a single task for a board.
  class Task < Librum::Components::Bulma::Base
    dependency :routes

    option :task, required: true, validate: ::Task

    private

    def render_label
      icon      =
        Lodestone::Tasks::View::Components.task_type_icon(task.task_type)
      component = components::Label.new(
        icon:,
        text: task.task_type.titleize
      )

      render(component)
    end

    def render_link
      color     = Lodestone::Tasks::View::Components.status_color(task.status)
      component = components::Link.new(
        color:,
        text:  task.title,
        url:   routes.task_path(task.slug)
      )

      render(component)
    end
  end
end
