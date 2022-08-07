# frozen_string_literal: true

FactoryBot.define do
  factory :task_relationship, class: 'TaskRelationship' do
    blocks_complete   { false }
    blocks_start      { false }
    relationship_type { TaskRelationship::RelationshipTypes::DEPENDS_ON.key }
  end
end
