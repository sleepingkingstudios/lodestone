# frozen_string_literal: true

module Lodestone::Projects::View::Components
  # Renders the create or update form for a project.
  class Form < Librum::Components::Views::Resources::Elements::Form
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
        cancel_url:,
        col_span:   6,
        icon:       'plus',
        text:       submit_text
      )
    end.freeze
    private_constant :FIELDS

    private

    def form_options
      super.merge(columns: 6)
    end

    def project_types
      @project_types ||= Project::ProjectTypes.each_value.map do |value|
        { label: value.titleize, value: value }
      end
    end
  end
end
