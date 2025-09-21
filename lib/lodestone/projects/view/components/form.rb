# frozen_string_literal: true

module Lodestone::Projects::View::Components
  # Renders the create or update form for a project.
  class Form < Librum::Components::Base
    FIELDS = lambda do |form|
      form.input 'project[name]', col_span: 2

      form.input 'project[slug]', col_span: 2

      form.select 'project[project_type]',
        col_span:    2,
        placeholder: ' ',
        values:      project_types

      form.input 'project[repository]', col_span: 4

      form.checkbox 'project[active]', inline: false

      form.checkbox 'project[public]', inline: false

      form.text_area 'project[description]', col_span: 6

      form.buttons(
        cancel_url: routes.index_path,
        col_span:   6,
        icon:       'plus',
        text:       'Create Project'
      )
    end.freeze
    private_constant :FIELDS

    allow_extra_options

    option :result

    option :resource

    option :routes

    def call
      component =
        components::Form
        .new(
          action:      form_action,
          columns:     6,
          http_method: form_http_method,
          result:
        )
        .build { |form| instance_exec(form, &FIELDS) }

      render(component)
    end

    private

    def action_name
      result.metadata['action_name']
    end

    def create_form?
      action_name == :create || action_name == :new # rubocop:disable Style/MultipleComparison
    end

    def form_action
      create_form? ? routes.create_path : routes.update_path
    end

    def form_http_method
      create_form? ? :post : :patch
    end

    def project_types
      @project_types ||= Project::ProjectTypes.each_value.map do |value|
        { label: value.titleize, value: value }
      end
    end
  end
end
