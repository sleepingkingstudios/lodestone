# frozen_string_literal: true

module Lodestone::Projects::View::Components
  # Renders the actions for a Project table row.
  class TableActions < Librum::Components::Bulma::Resources::TableActions
    allow_extra_options

    private

    def actions
      super.prepend build_board_action
    end

    def build_board_action
      components::Button.new(
        class_name: bulma_class_names(
          'has-text-success is-borderless is-shadowless mx-0 px-1 py-0'
        ),
        text:       'Board',
        type:       'link',
        url:        "#{routes.show_path(resource_id)}/board"
      )
    end
  end
end
