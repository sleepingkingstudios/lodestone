# frozen_string_literal: true

FactoryBot.define do
  factory :project, class: 'Project' do
    id { SecureRandom.uuid }

    transient do
      sequence(:project_index) { |i| i }
    end

    name         { "Project #{project_index}" }
    slug         { name.split.map(&:underscore).join('_').tr('_', '-') }
    active       { true }
    description  { "The description for project #{project_index}." }
    project_type { Project::ProjectTypes::APPLICATION }
    public       { true }
    repository   { "example.com/projects/#{slug}" }
  end
end
