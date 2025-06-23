# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/provider'

require 'support/fixtures'
require 'support/examples/commands'

module Spec::Support::Examples::Commands
  module TasksExamples
    include RSpec::SleepingKingStudios::Deferred::Provider

    deferred_context 'when the collection has many items' do
      include Cuprum::Rails::RSpec::Deferred::Commands::ResourcesExamples

      include_deferred 'when the collection is defined'

      let(:projects_collection) do
        repository['projects']
      end
      let(:projects_data) do
        Spec::Support::Fixtures::PROJECTS_FIXTURES
      end
      let(:collection_data) do
        fixtures_data.map { |attributes| Task.new(attributes) }
      end

      before(:example) do
        projects_data.each do |attributes|
          next if projects_collection.query.where(id: attributes['id']).exists? # rubocop:disable Rails/WhereExists

          entity = Project.new(attributes)
          result = projects_collection.insert_one.call(entity:)

          # :nocov:
          raise result.error.message if result.failure?
          # :nocov:
        end

        collection_data.each do |entity|
          result = collection.insert_one.call(entity:)

          # :nocov:
          raise result.error.message if result.failure?
          # :nocov:
        end
      end
    end

    deferred_context 'with parameters for a Task command' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:repository) do
        Cuprum::Rails::Records::Repository.new.tap do |repository|
          repository.create(
            entity_class:     Project,
            primary_key_type: String
          )
        end
      end
      let(:resource) do
        Cuprum::Rails::Resource.new(name: 'tasks', **resource_options)
      end
      let(:resource_options) do
        {
          default_order:        'id',
          permitted_attributes:,
          primary_key_name:     'id'
        }
      end
      let(:permitted_attributes) do
        %w[
          description
          project
          project_id
          project_index
          slug
          status
          task_type
          title
        ]
      end
      let(:collection_options) { { primary_key_type: String } }
      let(:default_contract) do
        Stannum::Contracts::HashContract.new(allow_extra_keys: true) do
          key 'title',         Stannum::Constraints::Presence.new
          key 'status',        Stannum::Constraints::Presence.new
          key 'project_index', Stannum::Constraints::Types::IntegerType.new
        end
      end
      let(:fixtures_data) { Spec::Support::Fixtures::TASKS_FIXTURES }

      ##########################################################################
      ###                         Querying Parameters                        ###
      ##########################################################################

      let(:invalid_primary_key_value) do
        SecureRandom.uuid
      end
      let(:resource_scope) do
        project_id = Spec::Support::Fixtures::PROJECTS_FIXTURES.first['id']

        Cuprum::Collections::Scope.new({ 'project_id' => project_id })
      end
      let(:non_matching_scope) do
        project_id = SecureRandom.uuid

        Cuprum::Collections::Scope.new({ 'project_id' => project_id })
      end
      let(:unique_scope) do
        Cuprum::Collections::Scope.new({
          'status' => Task::Statuses::WONT_DO.key
        })
      end
      let(:order) { { 'title' => 'asc' } }

      ##########################################################################
      ###                         Resource Parameters                        ###
      ##########################################################################

      let(:empty_attributes) do
        {
          'description' => '',
          'project_id'  => nil,
          'status'      => Task::Statuses::ICEBOX.key,
          'task_type'   => Task::TaskTypes::FEATURE,
          'title'       => ''
        }
      end
      let(:extra_attributes) do
        {
          'github_issue_url' => false
        }
      end
      let(:invalid_attributes) do
        {
          'title'  => 'Example Task',
          'status' => nil
        }
      end
      let(:valid_project_id) do
        Spec::Support::Fixtures::PROJECTS_FIXTURES.first['id']
      end
      let(:valid_attributes) do
        {
          'description' => 'Example description',
          'title'       => 'Example Task',
          'status'      => Task::Statuses::TO_DO.key
        }
      end
    end
  end
end
