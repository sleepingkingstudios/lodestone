# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/rspec/deferred/controller_examples'
require 'cuprum/rails/rspec/deferred/responder_examples'
require 'cuprum/rails/rspec/deferred/responses/html_response_examples'

RSpec.describe TasksController, type: :controller do
  include Cuprum::Rails::RSpec::Deferred::ControllerExamples

  describe '::Responder' do
    include Cuprum::Rails::RSpec::Deferred::ResponderExamples
    include Cuprum::Rails::RSpec::Deferred::Responses::HtmlResponseExamples

    subject(:responder) do
      described_class::Responder.new(**constructor_options)
    end

    let(:member_action) { false }
    let(:constructor_options) do
      {
        action_name:,
        controller:,
        member_action:,
        request:
      }
    end
    let(:resource) do
      Cuprum::Rails::Resource.new(name: 'tasks', singular: false)
    end

    describe '#call' do
      let(:path_params) { {} }
      let(:request) do
        Cuprum::Rails::Request.new(action_name:, path_params:)
      end
      let(:result)   { Cuprum::Result.new }
      let(:response) { responder.call(result) }

      context 'with action_name: "status"' do
        let(:action_name) { 'status' }

        describe 'with a failing result' do
          let(:error)  { Cuprum::Error.new(message: 'Something went wrong') }
          let(:result) { Cuprum::Result.new(error:) }
          let(:expected_flash) do
            message = 'Unable to update task status'

            { warning: { icon: 'exclamation-triangle', message: } }
          end

          include_deferred 'should redirect back',
            flash:  -> { expected_flash },
            status: 303
        end

        describe 'with a passing result' do # rubocop:disable RSpec/MultipleMemoizedHelpers
          let(:task) do
            FactoryBot.create(:task, :with_project, :wont_do)
          end
          let(:value)       { { 'task' => task } }
          let(:result)      { Cuprum::Result.new(value:) }
          let(:path_params) { { task_id: task.slug } }
          let(:request) do
            Cuprum::Rails::Request.new(action_name:, path_params:)
          end
          let(:expected_flash) do
            message = "Updated task status to Won't Do"

            { success: { icon: 'circle-check', message: } }
          end

          include_deferred 'should redirect to',
            -> { resource.routes.show_path(task.slug) },
            flash:  -> { expected_flash },
            status: 303
        end
      end
    end
  end

  describe '.resource' do
    subject(:resource) { described_class.resource }

    let(:components) do
      Lodestone::Tasks::View::Components
    end
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

    it { expect(resource).to be_a Librum::Components::Resource }

    it { expect(resource.components).to be components }

    it { expect(resource.default_order).to be :slug }

    it { expect(resource.entity_class).to be == Task }

    it { expect(resource.permitted_attributes).to be == permitted_attributes }

    it { expect(resource.title_attribute).to be == 'title' }
  end

  include_deferred 'should respond to format',
    :html,
    using: described_class::Responder

  include_deferred 'should define middleware',
    Cuprum::Rails::Actions::Middleware::Resources::Find,
    actions:  { only: %i[create new edit update] },
    matching: lambda {
      have_attributes(
        only_form_actions?: true,
        resource:           have_attributes(entity_class: Project)
      )
    }

  include_deferred 'should define middleware',
    Cuprum::Rails::Actions::Middleware::Associations::Find,
    actions:  { only: %i[show] },
    matching: lambda {
      have_attributes(
        association_type: :has_many,
        association:      have_attributes(
          entity_class:     TaskRelationship,
          foreign_key_name: 'source_task_id',
          name:             'relationships'
        )
      )
    }

  include_deferred 'should define middleware',
    Cuprum::Rails::Actions::Middleware::Associations::Find,
    actions:  { only: %i[show] },
    matching: lambda {
      have_attributes(
        association_type: :has_many,
        association:      have_attributes(
          entity_class:     TaskRelationship,
          foreign_key_name: 'target_task_id',
          name:             'inverse_relationships'
        )
      )
    }

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
    :status,
    Cuprum::Rails::Actions::Resources::Update,
    command_class: Lodestone::Tasks::Commands::Status,
    member:        true

  include_deferred 'should define action',
    :update,
    Cuprum::Rails::Actions::Resources::Update,
    command_class: Lodestone::Tasks::Commands::Update,
    member:        true
end
