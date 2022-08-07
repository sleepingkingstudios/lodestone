# frozen_string_literal: true

class RemoveBlockingFromTaskRelationships < ActiveRecord::Migration[7.0]
  def change
    remove_column \
      :task_relationships,
      :blocking,
      :boolean,
      null:    false,
      default: false
  end
end
