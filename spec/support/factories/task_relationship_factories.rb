# frozen_string_literal: true

FactoryBot.define do
  factory :task_relationship, class: 'TaskRelationship' do
    relationship_type { TaskRelationship::RelationshipTypes::DEPENDS_ON.key }
  end
end
