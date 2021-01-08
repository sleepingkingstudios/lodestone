# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbox/constant_map'

# Represents a project, such as a library or application.
class Project < ApplicationRecord
  ProjectTypes = SleepingKingStudios::Tools::Toolbox::ConstantMap.new(
    {
      APPLICATION: 'application',
      LIBRARY:     'library',
      SCRIPT:      'script'
    }
  ).freeze

  ### Validations
  validates :active,
    exclusion: {
      in:      [nil],
      message: I18n.t('errors.messages.blank')
    }
  validates :description, presence: true
  validates :name, presence: true
  validates :project_type,
    inclusion: {
      allow_nil: true,
      in:        ProjectTypes.all.values,
      message:   'must be application, library, or script'
    },
    presence:  true
  validates :public,
    exclusion: {
      in:      [nil],
      message: I18n.t('errors.messages.blank')
    }
  validates :slug,
    format:     {
      message: 'must be in kebab-case',
      with:    /\A[a-z0-9]+(-[a-z0-9]+)*\z/
    },
    presence:   true,
    uniqueness: true
end

# == Schema Information
#
# Table name: projects
#
#  id           :uuid             not null, primary key
#  active       :boolean          default(TRUE), not null
#  description  :text             default(""), not null
#  name         :string           default(""), not null
#  project_type :string           default(""), not null
#  public       :boolean          default(TRUE), not null
#  repository   :string           default(""), not null
#  slug         :string           default(""), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_projects_on_slug  (slug) UNIQUE
#
