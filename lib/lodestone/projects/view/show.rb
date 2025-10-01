# frozen_string_literal: true

module Lodestone::Projects::View
  # View displaying the current project.
  class Show < Librum::Components::Views::Resources::Show
    private

    def render_after_content
      return if resource_data.blank?

      CommonMarker
        .render_html(
          resource_data.description,
          :DEFAULT,
          %i[table tasklist strikethrough tagfilter]
        )
        .html_safe # rubocop:disable Rails/OutputSafety
    end

    def render_before_content
      return if resource_data.blank?

      component = components::Link.new(
        color: 'link',
        icon:  'rectangle-list',
        text:  'Project Board',
        url:   "/projects/#{resource_data['slug']}/board"
      )

      content_tag('p') { render(component) }
    end
  end
end
