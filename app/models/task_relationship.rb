# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbox/constant_map'

# Represents a relation between two tasks.
class TaskRelationship < ApplicationRecord
  # @api private
  RelationshipType = Struct.new(:key, :name, :inverse_name, keyword_init: true)

  RelationshipTypes = SleepingKingStudios::Tools::Toolbox::ConstantMap.new(
    {
      BELONGS_TO:  RelationshipType.new(
        key:          'belongs_to',
        name:         'belongs to',
        inverse_name: 'has child'
      ),
      DEPENDS_ON:  RelationshipType.new(
        key:          'depends_on',
        name:         'depends on',
        inverse_name: 'dependency of'
      ),
      MERGED_INTO: RelationshipType.new(
        key:          'merged_into',
        name:         'merged into',
        inverse_name: 'merged from'
      ),
      RELATES_TO:  RelationshipType.new(
        key:          'relates_to',
        name:         'relates to',
        inverse_name: 'related to'
      )
    }
  ).freeze

  ### Attributes
  attribute :relationship_type,
    :string,
    default: -> { RelationshipTypes::DEPENDS_ON.key }

  ### Associations
  belongs_to :source_task,
    class_name: 'Task',
    inverse_of: :relationships

  belongs_to :target_task,
    class_name: 'Task',
    inverse_of: :inverse_relationships

  ### Validations
  validates :relationship_type,
    inclusion: { in: RelationshipTypes.values.map(&:key) },
    presence:  true
  validate :target_task_must_not_match_source_task

  private

  def target_task_must_not_match_source_task
    return if source_task_id.nil?
    return unless source_task_id == target_task_id

    errors.add(:target_task, 'must not match source task')
  end
end

# == Schema Information
#
# Table name: task_relationships
#
#  id                :uuid             not null, primary key
#  relationship_type :string           default("depends_on"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  source_task_id    :uuid
#  target_task_id    :uuid
#
# Indexes
#
#  index_task_relationships_on_source_task_id  (source_task_id)
#  index_task_relationships_on_target_task_id  (target_task_id)
#
# Foreign Keys
#
#  fk_rails_...  (source_task_id => tasks.id)
#  fk_rails_...  (target_task_id => tasks.id)
#
