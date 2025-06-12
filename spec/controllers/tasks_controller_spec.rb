# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/rspec/deferred/controller_examples'

RSpec.describe TasksController, type: :controller do
  include Cuprum::Rails::RSpec::Deferred::ControllerExamples

  describe '.resource' do
    subject(:resource) { described_class.resource }

    let(:permitted_attributes) do
      %w[
        description
        project
        project_id
        slug
        status
        task_type
        title
      ]
    end

    it { expect(resource).to be_a Cuprum::Rails::Resource }

    it { expect(resource.default_order).to be :slug }

    it { expect(resource.entity_class).to be == Task }

    it { expect(resource.permitted_attributes).to be == permitted_attributes }
  end

  include_deferred 'should define middleware',
    lambda {
      an_instance_of(Cuprum::Rails::Actions::Middleware::Resources::Find)
        .and(
          have_attributes(
            only_form_actions?: true,
            resource:           have_attributes(entity_class: Project)
          )
        )
    },
    only: %i[create new edit update]

  include_deferred 'should define middleware',
    lambda {
      an_instance_of(Cuprum::Rails::Actions::Middleware::Associations::Find)
        .and(
          have_attributes(
            association_type: :has_many,
            association:      have_attributes(
              entity_class:     TaskRelationship,
              foreign_key_name: 'source_task_id',
              name:             'relationships'
            )
          )
        )
    },
    only: %i[show]

  include_deferred 'should define middleware',
    lambda {
      an_instance_of(Cuprum::Rails::Actions::Middleware::Associations::Find)
        .and(
          have_attributes(
            association_type: :has_many,
            association:      have_attributes(
              entity_class:     TaskRelationship,
              foreign_key_name: 'target_task_id',
              name:             'inverse_relationships'
            )
          )
        )
    },
    only: %i[show]

  include_deferred 'should define action',
    :create,
    Cuprum::Rails::Actions::Resources::Create,
    command_class: Lodestone::Tasks::Commands::Create,
    member:        false

  include_deferred 'should define action',
    :destroy,
    Cuprum::Rails::Actions::Resources::Destroy,
    command_class: Librum::Core::Commands::Resources::Destroy,
    member:        true

  include_deferred 'should define action',
    :edit,
    Cuprum::Rails::Actions::Resources::Edit,
    command_class: Lodestone::Tasks::Commands::Edit,
    member:        true

  include_deferred 'should define action',
    :index,
    Cuprum::Rails::Actions::Resources::Index,
    command_class: Cuprum::Rails::Commands::Resources::Index,
    member:        false

  include_deferred 'should define action',
    :new,
    Cuprum::Rails::Actions::Resources::New,
    command_class: Lodestone::Tasks::Commands::New,
    member:        false

  include_deferred 'should define action',
    :show,
    Cuprum::Rails::Actions::Resources::Show,
    command_class: Librum::Core::Commands::Resources::Show,
    member:        true

  include_deferred 'should define action',
    :update,
    Cuprum::Rails::Actions::Resources::Update,
    command_class: Lodestone::Tasks::Commands::Update,
    member:        true
end
