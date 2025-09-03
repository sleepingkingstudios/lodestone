# frozen_string_literal: true

require 'librum/components'

module Lodestone::View::Layouts
  # Configured page layout for Lodestone pages.
  class Page < Librum::Components::Base
    dependency :routes

    # @return [ActiveSupport::SafeBuffer] the rendered page.
    def call
      page =
        components::Layouts::Page
        .new(**page_options)
        .with_content(content)

      render(page)
    end

    private

    def brand
      { icon: 'compass' }
    end

    def color
      'success'
    end

    def copyright
      {
        holder: "Rob\u00A0Smith",
        scope:  "Sleeping\u00A0King\u00A0Studios",
        year:   "2021-#{Time.zone.today.year}"
      }
    end

    def navigation
      [
        { label: 'Board',    url: routes.board_path },
        { label: 'Projects', url: routes.projects_path },
        { label: 'Tasks',    url: routes.tasks_path }
      ]
    end

    def page_options
      {
        brand:,
        color:,
        copyright:,
        navigation:,
        tagline:,
        title:
      }
    end

    def tagline
      "Non\u00A0Sufficit\u00A0Orbis"
    end

    def title
      'Lodestone'
    end
  end
end
