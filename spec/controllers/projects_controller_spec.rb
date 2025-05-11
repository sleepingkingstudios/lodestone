# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/rspec/deferred/controller_examples'

RSpec.describe ProjectsController, type: :controller do
  include Cuprum::Rails::RSpec::Deferred::ControllerExamples

  describe '.resource' do
    subject(:resource) { described_class.resource }

    let(:permitted_attributes) do
      %w[
        active
        description
        name
        project_type
        public
        repository
        slug
      ]
    end

    it { expect(resource).to be_a Cuprum::Rails::Resource }

    it { expect(resource.default_order).to be :name }

    it { expect(resource.entity_class).to be == Project }

    it { expect(resource.permitted_attributes).to be == permitted_attributes }
  end

  include_deferred 'should define action',
    :create,
    Cuprum::Rails::Actions::Resources::Create,
    command_class: Librum::Core::Commands::Resources::Create,
    member:        false

  include_deferred 'should define action',
    :destroy,
    Cuprum::Rails::Actions::Resources::Destroy,
    command_class: Librum::Core::Commands::Resources::Destroy,
    member:        true

  include_deferred 'should define action',
    :edit,
    Cuprum::Rails::Actions::Resources::Edit,
    command_class: Librum::Core::Commands::Resources::Edit,
    member:        true

  include_deferred 'should define action',
    :index,
    Cuprum::Rails::Actions::Resources::Index,
    command_class: Cuprum::Rails::Commands::Resources::Index,
    member:        false

  include_deferred 'should define action',
    :new,
    Cuprum::Rails::Actions::Resources::New,
    command_class: Librum::Core::Commands::Resources::New,
    member:        false

  include_deferred 'should define action',
    :show,
    Cuprum::Rails::Actions::Resources::Show,
    command_class: Librum::Core::Commands::Resources::Show,
    member:        true

  include_deferred 'should define action',
    :update,
    Cuprum::Rails::Actions::Resources::Update,
    command_class: Librum::Core::Commands::Resources::Update,
    member:        true
end
