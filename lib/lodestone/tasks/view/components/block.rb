# frozen_string_literal: true

module Lodestone::Tasks::View::Components
  # Renders the block for a Tasks show view.
  class Block < Librum::Components::Views::Resources::Elements::Block
    FIELDS = lambda do
      [
        { key: 'slug' },
        { key: 'project', value: ->(task) { project_link(task) } },
        { key: 'task_type', transform: :titleize },
        {
          key:   'status',
          value: lambda do |task|
            Lodestone::Tasks::View::Components.format_status(task&.status)
          end
        }
      ].freeze
    end.freeze
    private_constant :FIELDS

    private

    def project_link(task)
      return if task&.project.blank?

      project = task.project

      component = components::Link.new(
        text: project.name,
        url:  "/projects/#{project.slug}"
      )

      render(component)
    end
  end
end
