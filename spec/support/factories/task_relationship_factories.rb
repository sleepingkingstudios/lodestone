# frozen_string_literal: true

FactoryBot.define do
  factory :task_relationship, class: 'TaskRelationship' do
    blocking          { false }
    relationship_type { TaskRelationship::RelationshipTypes::DEPENDS_ON }
  end
end
