# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbox/constant_map'

# Represents a specific achievable task, such as a bug or feature.
class Task < ApplicationRecord
  # @api private
  Status = Struct.new(:key, :name)

  Statuses = SleepingKingStudios::Tools::Toolbox::ConstantMap.new(
    {
      WONT_DO:     Status.new('wont_do',     "won't do"),
      ICEBOX:      Status.new('icebox',      'icebox'),
      TO_DO:       Status.new('to_do',       'to do'),
      IN_PROGRESS: Status.new('in_progress', 'in progress'),
      DONE:        Status.new('done',        'done'),
      ARCHIVED:    Status.new('archived',    'archived')
    }
  ).freeze

  TaskTypes = SleepingKingStudios::Tools::Toolbox::ConstantMap.new(
    {
      BUGFIX:        'bugfix',
      CHORE:         'chore',
      FEATURE:       'feature',
      INVESTIGATION: 'investigation',
      RELEASE:       'release'
    }
  ).freeze

  ### Attributes
  attribute :status,    :string, default: Statuses::ICEBOX.key
  attribute :task_type, :string, default: TaskTypes::FEATURE

  ### Associations
  belongs_to :project
  has_many :inverse_relationships,
    class_name:  'TaskRelationship',
    dependent:   :destroy,
    foreign_key: :target_task_id,
    inverse_of:  :target_task
  has_many :relationships,
    class_name:  'TaskRelationship',
    dependent:   :destroy,
    foreign_key: :source_task_id,
    inverse_of:  :source_task

  ### Validations
  validates :description, presence: true
  validates :project_index,
    numericality: {
      greater_than_or_equal_to: 0,
      only_integer:             true
    },
    presence:     true
  validates :slug,
    format:     {
      message: 'must be in kebab-case',
      with:    /\A[a-z0-9]+(-[a-z0-9]+)*\z/
    },
    presence:   true,
    uniqueness: true
  validates :status,
    inclusion: { in: Statuses.values.map(&:key) },
    presence:  true
  validates :task_type,
    inclusion: { in: TaskTypes.values },
    presence:  true
  validates :title, presence: true
end

# == Schema Information
#
# Table name: tasks
#
#  id            :uuid             not null, primary key
#  description   :text             default(""), not null
#  project_index :integer          not null
#  slug          :string           default(""), not null
#  status        :string           default("icebox"), not null
#  task_type     :string           default("feature"), not null
#  title         :string           default(""), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  project_id    :uuid
#
# Indexes
#
#  index_tasks_on_project_id  (project_id)
#  index_tasks_on_slug        (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
