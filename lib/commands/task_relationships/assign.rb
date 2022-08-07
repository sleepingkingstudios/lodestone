# frozen_string_literal: true

require 'cuprum'

require 'commands/task_relationships'

module Commands::TaskRelationships
  # Updates the attributes for a task relationship.
  class Assign < Cuprum::Command
    private

    def process(attributes:, entity:)
      attributes = attributes.merge(relationship_type_params(attributes))

      entity.assign_attributes(attributes)
    end

    def relationship_type_params(attributes)
      relationship_key  = attributes['relationship_type']
      relationship_type =
        TaskRelationship::RelationshipTypes
        .values
        .find { |type| type.key == relationship_key }

      return {} if relationship_type.blank?

      {
        blocks_complete: relationship_type.blocks_complete,
        blocks_start:    relationship_type.blocks_start
      }
    end
  end
end
