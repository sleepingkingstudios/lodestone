# frozen_string_literal: true

module Lodestone::Tasks::View::Components::Relationships
  # Renders the actions for a TaskRelationships table view.
  class TableActions < Librum::Components::Bulma::Resources::TableActions
    private

    def routes
      @routes ||= super.with_wildcards({ 'task_id' => data.source_task.slug })
    end
  end
end
