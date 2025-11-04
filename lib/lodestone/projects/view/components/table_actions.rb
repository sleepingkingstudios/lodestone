# frozen_string_literal: true

module Lodestone::Projects::View::Components
  # Renders the actions for a Project table row.
  class TableActions < Librum::Components::Bulma::Resources::TableActions
    private

    def actions
      super.prepend build_board_action
    end

    def build_board_action
      components::Button.new(
        class_name: bulma_class_names('px-1'),
        color:      'success',
        link:       true,
        text:       'Board',
        type:       'link',
        url:        "#{routes.show_path(resource_id)}/board"
      )
    end
  end
end
