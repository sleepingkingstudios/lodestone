# frozen_string_literal: true

module Lodestone::Tasks::View::Components::Relationships
  # Component class rendering a task relationships data table.
  class Table < Librum::Components::Base
    COLUMNS = lambda do
      [
        {
          key:   'relationship_type',
          label: 'Type',
          value: ->(relationship) { relationship_type(relationship) }
        },
        {
          key:   'project',
          value: ->(relationship) { project_link(relationship) }
        },
        {
          key:   'task',
          value: ->(relationship) { task_link(relationship) }
        },
        {
          key:   'actions',
          label: "\u00A0",
          type:  'actions'
        }
      ].freeze
    end.freeze
    private_constant :COLUMNS

    option :inverse_relationships, validate: Array
    option :relationships,         validate: Array
    option :resource,              required: true
    option :routes,                required: true
    option :task

    # @return [ActiveSupport::SafeBuffer] the rendered table.
    def call # rubocop:disable Metrics/MethodLength
      component = components::DataTable.new(
        body_component:,
        class_name:            'multi-body',
        columns:,
        data:,
        inverse_relationships:,
        relationships:,
        resource:,
        routes:,
        task:
      )

      render(component)
    end

    private

    def body_component
      Lodestone::Tasks::View::Components::Relationships::TableBody
    end

    def columns
      instance_exec(&COLUMNS)
    end

    def data
      []
    end

    def inverse_relationship?(relationship)
      task == relationship.target_task
    end

    def other_task(relationship)
      return relationship.source_task if inverse_relationship?(relationship)

      relationship.target_task
    end

    def project_link(relationship)
      return unless task

      project = other_task(relationship)&.project

      return unless project

      component = components::Link.new(
        text: project.name,
        url:  "/projects/#{project.slug}"
      )

      render(component)
    end

    def relationship_type(relationship)
      default = 'Unknown Relationship Type'
      scope   = 'lodestone.task_relationships.relationship_types'
      key     = inverse_relationship?(relationship) ? 'inverse_name' : 'name'

      I18n.t(
        "#{relationship.relationship_type}.#{key}",
        default:,
        scope:
      )
    end

    def task_link(relationship)
      task = other_task(relationship)

      return unless task

      component = components::Link.new(
        color: Lodestone::Tasks::View::Components.status_color(task.status),
        text:  task.title,
        url:   "/tasks/#{task.slug}"
      )

      render(component)
    end
  end
end
