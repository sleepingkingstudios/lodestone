# frozen_string_literal: true

module Lodestone::Projects::View::Components
  # Renders the table for a Projects index view.
  class Table < Librum::Components::Views::Resources::Elements::Table
    include Librum::Components::Bulma::Mixin

    COLUMNS = [
      { key: 'name' },
      { key: 'active', type: :boolean },
      { key: 'public', type: :boolean },
      { key: 'project_type', transform: :titleize },
      {
        key:   'actions',
        label: "\u00A0",
        value: TableActions
      }
    ].freeze
    private_constant :COLUMNS

    allow_extra_options

    private

    def table_class_name
      class_names(
        super,
        bulma_class_names('is-striped')
      )
    end

    def table_options
      super.merge(
        row_component: Lodestone::Projects::View::Components::TableRow
      )
    end
  end
end
