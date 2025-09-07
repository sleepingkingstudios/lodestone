# frozen_string_literal: true

module Lodestone::Boards::View::Components
  # Component rendering a single task for a board.
  class Task < Librum::Components::Bulma::Base
    dependency :routes

    option :task, required: true, validate: ::Task

    ICON_CLASSES = {
      ::Task::TaskTypes::BUGFIX        => 'bug',
      ::Task::TaskTypes::CHORE         => 'wrench',
      ::Task::TaskTypes::EPIC          => 'lightbulb',
      ::Task::TaskTypes::FEATURE       => 'gear',
      ::Task::TaskTypes::INVESTIGATION => 'search',
      ::Task::TaskTypes::MILESTONE     => 'trophy',
      ::Task::TaskTypes::RELEASE       => 'award'
    }.freeze
    private_constant :ICON_CLASSES

    LINK_COLORS = {
      ::Task::Statuses::DONE        => 'slate',
      ::Task::Statuses::ICEBOX      => 'info',
      ::Task::Statuses::IN_PROGRESS => 'success',
      ::Task::Statuses::TO_DO       => 'link'
    }.freeze
    private_constant :LINK_COLORS

    private

    def render_label
      component = components::Label.new(
        icon: ICON_CLASSES.fetch(task.task_type),
        text: task.task_type.titleize
      )

      render(component)
    end

    def render_link
      component = components::Link.new(
        color: LINK_COLORS.fetch(task.status),
        text:  task.title,
        url:   routes.task_path(task.slug)
      )

      render(component)
    end
  end
end
