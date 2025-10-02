# frozen_string_literal: true

module Lodestone::Tasks::View::Components
  # Renders the create or update form for a task.
  class Form < Librum::Components::Views::Resources::Elements::Form
    FIELDS = lambda do |form|
      form.input 'task[title]', col_span: 3

      form.select 'task[project_id]',
        placeholder: ' ',
        values:      projects

      form.select 'task[task_type]', values: task_types

      form.select 'task[status]', values: statuses

      form.text_area 'task[description]', col_span: 3

      form.buttons(
        cancel_url:,
        col_span:   3,
        icon:       'plus',
        text:       submit_text
      )
    end
    private_constant :FIELDS

    private

    def default_projects
      [{ label: 'No Projects Found', value: nil }]
    end

    def form_options
      super.merge(columns: 3)
    end

    def projects
      return @projects if @projects

      result
        .value
        &.[]('projects')
        &.map { |project| { label: project.name, value: project.id } }
        .then { |items| items.presence || default_projects }
    end

    def statuses
      @statuses ||= Task::Statuses.each_value.map do |value|
        {
          label: Lodestone::Tasks::View::Components.format_status(value),
          value: value
        }
      end
    end

    def task_types
      @task_types ||= Task::TaskTypes.each_value.map do |value|
        {
          label: value.titleize,
          value: value
        }
      end
    end
  end
end
