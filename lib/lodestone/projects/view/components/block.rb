# frozen_string_literal: true

module Lodestone::Projects::View::Components
  # Renders the block for a Projects show view.
  class Block < Librum::Components::Views::Resources::Elements::Block
    allow_extra_options

    FIELDS = [
      { key: 'name' },
      { key: 'active', type: :boolean },
      { key: 'public', type: :boolean },
      { key: 'project_type', transform: :titleize },
      { key: 'repository' }
    ].freeze
    private_constant :FIELDS

    private

    def render_board_link
      return if data.blank?

      component = components::Link.new(
        color: 'link',
        icon:  'rectangle-list',
        text:  'Project Board',
        url:   "/projects/#{data['slug']}/board"
      )

      content_tag('p') { render(component) }
    end

    def render_description
      return if data.blank?

      CommonMarker
        .render_html(
          data.description,
          :DEFAULT,
          %i[table tasklist strikethrough tagfilter]
        )
        .html_safe # rubocop:disable Rails/OutputSafety
    end
  end
end
