# frozen_string_literal: true

module Lodestone::Tasks::View::Components
  # Renders the table for a Tasks index view.
  class Table < Librum::Components::Views::Resources::Elements::Table
    COLUMNS = [
      { key: 'slug', label: 'Task' },
      { key: 'title' },
      { key: 'task_type', transform: :titleize },
      {
        key:   'status',
        value: lambda do |task|
          Lodestone::Tasks::View::Components.format_status(task&.status)
        end
      },
      {
        key:   'actions',
        label: "\u00A0",
        type:  'actions'
      }
    ].freeze
    private_constant :COLUMNS
  end
end
