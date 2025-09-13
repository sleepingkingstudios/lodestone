# frozen_string_literal: true

module Lodestone::Projects::View::Components
  # Renders the table for a Projects index view.
  class Table < Librum::Components::Base
    COLUMNS = [
      { key: 'name' },
      { key: 'active', type: :boolean },
      { key: 'public', type: :boolean },
      { key: 'project_type', transform: :titleize },
      {
        key:   'actions',
        label: "\u0020",
        value: TableActions
      }
    ].freeze

    option :data, validate: { array: Project }

    option :resource

    option :routes

    def call
      render components::DataTable.new(
        columns:,
        data:,
        empty_message:,
        resource:,
        routes:
      )
    end

    private

    def columns
      COLUMNS
    end

    def empty_message
      'There are no projects matching the criteria.'
    end
  end
end
