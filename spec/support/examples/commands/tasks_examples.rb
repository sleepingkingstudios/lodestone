# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/provider'

require 'support/fixtures'
require 'support/examples/commands'

module Spec::Support::Examples::Commands
  module TasksExamples
    include RSpec::SleepingKingStudios::Deferred::Provider

    deferred_context 'with parameters for a Task command' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:repository) { Cuprum::Collections::Basic::Repository.new }
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
        project = Spec::Support::Fixtures::PROJECTS_FIXTURES.find do |item|
          item['id'] == valid_project_id
        end

        {
          'title'      => 'Example Task',
          'status'     => Task::Statuses::TO_DO.key,
          'project_id' => valid_project_id,
          'project'    => project
        }
      end
    end
  end
end
