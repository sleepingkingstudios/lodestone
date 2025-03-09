# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/repository'

RSpec.describe Actions::Projects::Create do
  subject(:action) { described_class.new }

  let(:repository) { Cuprum::Rails::Records::Repository.new }
  let(:resource) do
    Cuprum::Rails::Resource.new(
      collection:           repository.find_or_create(record_class: Project),
      permitted_attributes: %i[
        active
        description
        name
        project_type
        public
        repository
        slug
      ],
      resource_class:       Project
    )
  end
  let(:invalid_attributes) do
    { 'name' => '' }
  end
  let(:valid_attributes) do
    {
      'active'       => false,
      'name'         => 'Example Project',
      'description'  => 'Description of an example project.',
      'project_type' => Project::ProjectTypes::APPLICATION,
      'public'       => false,
      'repository'   => 'www.example.com'
    }
  end
  let(:expected_attributes) do
    { 'slug' => 'example-project' }
  end

  pending 'Disabled due to removed contract'
end
