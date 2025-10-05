# frozen_string_literal: true

module Lodestone::TaskRelationships::View::Components
  # Renders the create or update form for a task relationship.
  class Form < Librum::Components::Views::Resources::Elements::Form
    FIELDS = lambda do |form|
      form.fields << source_task_input

      form.input 'task_relationship[source_task_id]',
        disabled: true,
        value:    task_label(source_task)

      form.select 'task_relationship[relationship_type]',
        values: relationship_types

      form.select 'task_relationship[target_task_id]',
        placeholder: "\u00A0",
        values:      target_tasks

      form.buttons(
        cancel_url:,
        col_span:   3,
        icon:       create_form? ? 'plus' : 'pencil',
        text:       submit_text
      )
    end
    private_constant :FIELDS

    private

    def cancel_url
      return '/tasks' unless source_task

      "/tasks/#{source_task.slug}"
    end

    def form_options
      super.merge(columns: 3)
    end

    def source_task
      result.value&.[]('source_task')
    end

    def relationship_types
      TaskRelationship::RelationshipTypes.each_value.map do |value|
        scope = 'lodestone.task_relationships.relationship_types'
        label = I18n.t("#{value}.name", scope:)

        {
          label:,
          value: value
        }
      end
    end

    def source_task_input
      components::Forms::Input.new(
        name:  'task_relationship[source_task_id]',
        type:  'hidden',
        value: source_task&.id
      )
    end

    def target_tasks
      grouped = result.value&.[]('tasks')

      return [] if grouped.blank?

      grouped.map do |label, tasks|
        {
          label:,
          items: tasks.map do |task|
            { label: task_label(task), value: task.id }
          end
        }
      end
    end

    def task_label(task)
      return "\u00A0" unless task

      "#{task.title} (#{task.slug})"
    end

    def submit_text
      create_form? ? 'Create Relationship' : 'Update Relationship'
    end
  end
end
