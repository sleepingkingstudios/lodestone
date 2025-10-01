# frozen_string_literal: true

module Lodestone::Tasks::View::Components::Relationships
  # Component class rendering the body for a task relationships data table.
  class TableBody < Librum::Components::Bulma::DataTable::Body
    option :inverse_relationships, validate: Array
    option :relationships,         validate: Array
    option :resource,              required: true
    option :routes,                required: true
    option :task

    private

    def render_relationship(relationship:)
      component = components::DataTable::Row.new(
        class_name: 'joined-rows',
        columns:,
        data:       relationship,
        resource:,
        routes:
      )

      render(component)
    end
  end
end
