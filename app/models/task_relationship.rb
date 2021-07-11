# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbox/constant_map'

# Represents a relation between two tasks.
class TaskRelationship < ApplicationRecord
  RelationshipTypes = SleepingKingStudios::Tools::Toolbox::ConstantMap.new(
    {
      DEPENDS_ON: 'depends_on',
      RELATES_TO: 'relates_to'
    }
  ).freeze

  ### Attributes
  attribute :relationship_type, :string, default: RelationshipTypes::RELATES_TO

  ### Associations
  belongs_to :source_task,
    class_name: 'Task',
    inverse_of: :relationships

  belongs_to :target_task,
    class_name: 'Task',
    inverse_of: :inverse_relationships

  ### Validations
  validates :blocking,
    exclusion: {
      in:      [nil],
      message: I18n.t('errors.messages.blank')
    }
  validates :relationship_type,
    inclusion: { in: RelationshipTypes.values },
    presence:  true
  validate :target_task_must_not_match_source_task

  private

  def target_task_must_not_match_source_task
    return if source_task.nil?
    return unless source_task == target_task

    errors[:target_task] << 'must not match source task'
  end
end

# == Schema Information
#
# Table name: task_relationships
#
#  id                :uuid             not null, primary key
#  blocking          :boolean          default(FALSE), not null
#  relationship_type :string           default(""), not null
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
