# frozen_string_literal: true

require 'cuprum'

require 'commands/task_relationships'

module Commands::TaskRelationships
  # Builds a task relationship with the given tasks.
  class Build < Cuprum::Command
    private

    def process(attributes:)
      attributes = attributes.merge(relationship_type_params(attributes))

      TaskRelationship.new(attributes)
    end

    def relationship_type_params(attributes)
      relationship_key  = attributes['relationship_type']
      relationship_type =
        TaskRelationship::RelationshipTypes
        .values
        .find { |type| type.key == relationship_key }

      return {} if relationship_type.blank?

      { blocking: relationship_type.blocking }
    end
  end
end
