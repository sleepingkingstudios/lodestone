# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/rspec/deferred/controller_examples'

RSpec.describe TaskRelationshipsController, type: :controller do
  include Cuprum::Rails::RSpec::Deferred::ControllerExamples

  describe '::Responder' do
    subject(:responder) { described_class.new(**constructor_options) }

    let(:described_class) { super()::Responder }
    let(:action_name)     { :published }
    let(:controller)      { TaskRelationshipsController.new } # rubocop:disable RSpec/DescribedClass
    let(:request)         { Cuprum::Rails::Request.new }
    let(:constructor_options) do
      {
        action_name:,
        controller:,
        request:
      }
    end

    describe '#call' do
      shared_examples 'should redirect to the source task' do
        let(:routes) do
          Class.new.include(Rails.application.routes.url_helpers).new
        end
        let(:redirect_path) do
          routes.task_path(source_task.slug)
        end
        let(:response) { responder.call(result) }

        it 'should return a redirect response' do
          expect(response)
            .to be_a Cuprum::Rails::Responses::Html::RedirectResponse
        end

        it { expect(response.path).to be == redirect_path }

        it { expect(response.status).to be 302 } # rubocop:disable RSpecRails/HaveHttpStatus
      end

      let(:source_task) do
        FactoryBot.build(:task, id: SecureRandom.uuid)
      end
      let(:task_relationship) do
        FactoryBot.build(:task_relationship, source_task:)
      end

      describe 'with action_name: :create' do
        let(:action_name) { :create }

        describe 'with a passing result' do
          let(:value) do
            { 'task_relationship' => task_relationship }
          end
          let(:result) { Cuprum::Rails::Result.new(value:) }

          include_examples 'should redirect to the source task'
        end
      end

      describe 'with action_name: :destroy' do
        let(:action_name) { :destroy }

        describe 'with a passing result' do
          let(:value) do
            { 'task_relationship' => task_relationship }
          end
          let(:result) { Cuprum::Rails::Result.new(value:) }

          include_examples 'should redirect to the source task'
        end
      end

      describe 'with action_name: :update' do
        let(:action_name) { :update }

        describe 'with a passing result' do
          let(:value) do
            { 'task_relationship' => task_relationship }
          end
          let(:result) { Cuprum::Rails::Result.new(value:) }

          include_examples 'should redirect to the source task'
        end
      end
    end
  end

  describe '.resource' do
    subject(:resource) { described_class.resource }

    let(:components) do
      Lodestone::TaskRelationships::View::Components
    end
    let(:permitted_attributes) do
      %w[
        relationship_type
        source_task_id
        target_task_id
      ]
    end

    it { expect(resource).to be_a Librum::Components::Resource }

    it { expect(resource.components).to be components }

    it { expect(resource.entity_class).to be == TaskRelationship }

    it { expect(resource.permitted_attributes).to be == permitted_attributes }
  end

  include_deferred 'should respond to format',
    :html,
    using: described_class::Responder

  include_deferred 'should define middleware',
    Lodestone::TaskRelationships::Middleware::FindTasks,
    only: %i[create edit new update]

  include_deferred 'should define action',
    :create,
    Cuprum::Rails::Actions::Resources::Create,
    command_class: Cuprum::Rails::Commands::Resources::Create,
    member:        false

  include_deferred 'should define action',
    :destroy,
    Cuprum::Rails::Actions::Resources::Destroy,
    command_class: Cuprum::Rails::Commands::Resources::Destroy,
    member:        true

  include_deferred 'should define action',
    :edit,
    Cuprum::Rails::Actions::Resources::Edit,
    command_class: Cuprum::Rails::Commands::Resources::Edit,
    member:        true

  include_deferred 'should define action',
    :new,
    Cuprum::Rails::Actions::Resources::New,
    command_class: Cuprum::Rails::Commands::Resources::New,
    member:        false

  include_deferred 'should define action',
    :update,
    Cuprum::Rails::Actions::Resources::Update,
    command_class: Cuprum::Rails::Commands::Resources::Update,
    member:        true
end
