# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbox/constant_map'

# Represents a specific achievable task, such as a bug or feature.
class Task < ApplicationRecord
  Statuses = SleepingKingStudios::Tools::Toolbox::ConstantMap.new(
    {
      DONE:        'done',
      ICEBOX:      'icebox',
      IN_PROGRESS: 'in_progress',
      TODO:        'todo'
    }
  ).freeze

  TaskTypes = SleepingKingStudios::Tools::Toolbox::ConstantMap.new(
    {
      BUGFIX:        'bugfix',
      CHORE:         'chore',
      FEATURE:       'feature',
      INVESTIGATION: 'investigation'
    }
  ).freeze

  ### Attributes
  attribute :status,    :string, default: Statuses::ICEBOX
  attribute :task_type, :string, default: TaskTypes::FEATURE

  ### Associations
  belongs_to :project

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
    inclusion: { in: Statuses.values },
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
#  status        :string           default(""), not null
#  task_type     :string           default(""), not null
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
