# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/rspec/deferred/commands/resources/create_examples'
require 'cuprum/rails/rspec/matchers'

require 'support/examples/commands/tasks_examples'

RSpec.describe Lodestone::Tasks::Commands::Create do
  include Cuprum::Rails::RSpec::Deferred::Commands::Resources::CreateExamples
  include Cuprum::Rails::RSpec::Matchers
  include Spec::Support::Examples::Commands::TasksExamples

  subject(:command) { described_class.new(repository:, resource:) }

  let(:calculated_slug) { nil }
  let(:expected_slug) do
    matched = tools.hash_tools.convert_keys_to_strings(matched_attributes)

    next matched['slug'] if matched['slug'].present?

    calculated_slug
  end
  let(:expected_project_index) { nil }
  let(:expected_attributes) do
    empty_attributes
      .merge(tools.hash_tools.convert_keys_to_strings(matched_attributes))
      .merge(
        'id'            => be_a_uuid,
        'slug'          => expected_slug,
        'project_index' => expected_project_index
      )
  end

  define_method(:insert) do |collection_name, *entities|
    entities.each do |entity|
      result = repository[collection_name].insert_one.call(entity:)

      raise result.error.message if result.failure?
    end
  end

  define_method :tools do
    SleepingKingStudios::Tools::Toolbelt.instance
  end

  include_deferred 'with parameters for a Task command'

  describe 'with project: nil' do
    let(:matched_attributes) { valid_attributes }
    let(:expected_attributes) do
      super()
        .merge(
          'project_id' => nil,
          'created_at' => nil,
          'updated_at' => nil
        )
    end

    define_method :call_command do
      command.call(attributes: matched_attributes)
    end

    before(:example) do
      repository.create(
        default_contract:,
        name:             'tasks',
        primary_key_type: String
      )
    end

    include_deferred 'should validate the entity'
  end

  describe 'with project: value' do
    let(:project) do
      attributes = Spec::Support::Fixtures::PROJECTS_FIXTURES.find do |item|
        item['id'] == valid_project_id
      end

      Project.new(**attributes)
    end
    let(:empty_attributes)       { super().merge('project' => project) }
    let(:invalid_attributes)     { super().merge('project' => project) }
    let(:valid_attributes)       { super().merge('project' => project) }
    let(:expected_project_index) { 0 }
    let(:calculated_slug) do
      "#{project['slug']}-#{expected_project_index}"
    end
    let(:expected_attributes) do
      super()
        .except('project', :project)
        .merge('project_id' => project.id)
    end

    before(:example) { insert('projects', project) }

    include_deferred 'should implement the Create command',
      default_contract: true \
    do
      describe 'with slug: nil' do
        let(:matched_attributes) do
          configured_valid_attributes.merge('slug' => nil)
        end

        include_deferred 'should create the entity'
      end

      describe 'with slug: an empty String' do
        let(:matched_attributes) do
          configured_valid_attributes.merge('slug' => '')
        end

        include_deferred 'should create the entity'
      end

      describe 'with slug: value' do
        let(:slug) { 'custom-slug' }
        let(:matched_attributes) do
          configured_valid_attributes.merge('slug' => slug)
        end
        let(:expected_attributes) do
          super().merge('slug' => slug)
        end

        include_deferred 'should create the entity'
      end

      wrap_deferred 'when the collection has many items' do
        let(:matched_attributes) { configured_valid_attributes }
        let(:expected_project_index) do
          project_id = matched_attributes['project'].id

          fixtures_data
            .select { |task| task['project_id'] == project_id }
            .count
        end

        include_deferred 'should create the entity'
      end
    end
  end
end
