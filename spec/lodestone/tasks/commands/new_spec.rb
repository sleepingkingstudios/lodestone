# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/rspec/deferred/commands/resources/new_examples'

require 'support/examples/commands/tasks_examples'

RSpec.describe Lodestone::Tasks::Commands::New do
  include Cuprum::Rails::RSpec::Deferred::Commands::Resources::NewExamples
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

  include_deferred 'with parameters for a Task command'

  describe 'with project: nil' do
    include_deferred 'should implement the New command',
      default_contract: true \
    do
      describe 'with slug: nil' do
        let(:matched_attributes) do
          configured_valid_attributes.merge('slug' => nil)
        end

        include_deferred 'should build the entity'
      end

      describe 'with slug: an empty String' do
        let(:matched_attributes) do
          configured_valid_attributes.merge('slug' => '')
        end

        include_deferred 'should build the entity'
      end

      describe 'with slug: value' do
        let(:slug) { 'custom-slug' }
        let(:matched_attributes) do
          configured_valid_attributes.merge('slug' => slug)
        end
        let(:expected_attributes) do
          super().merge('slug' => slug)
        end

        include_deferred 'should build the entity'
      end
    end
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
    let(:extra_attributes)       { super().merge('project' => project) }
    let(:expected_project_index) { 0 }
    let(:calculated_slug) do
      "#{project['slug']}-#{expected_project_index}"
    end
    let(:expected_attributes) do
      super().except('project', :project).merge('project_id' => project.id)
    end

    before(:example) { insert('projects', project) }

    include_deferred 'should implement the New command',
      default_contract: true \
    do
      describe 'with slug: nil' do
        let(:matched_attributes) do
          configured_valid_attributes.merge('slug' => nil)
        end

        include_deferred 'should build the entity'
      end

      describe 'with slug: an empty String' do
        let(:matched_attributes) do
          configured_valid_attributes.merge('slug' => '')
        end

        include_deferred 'should build the entity'
      end

      describe 'with slug: value' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:slug) { 'custom-slug' }
        let(:matched_attributes) do
          configured_valid_attributes.merge('slug' => slug)
        end
        let(:expected_attributes) do
          super().merge('slug' => slug)
        end

        include_deferred 'should build the entity'
      end

      wrap_deferred 'when the collection has many items' do
        let(:expected_project_index) do
          fixtures_data
            .select { |task| task['project_id'] == project['id'] }
            .count
        end
        let(:matched_attributes) { configured_valid_attributes }

        include_deferred 'should build the entity'
      end
    end
  end

  describe 'with project_id: invalid id' do
    let(:project_id) { SecureRandom.uuid }
    let(:matched_attributes) do
      valid_attributes.merge('project_id' => project_id)
    end
    let(:expected_error) do
      Cuprum::Collections::Errors::NotFound.new(
        attribute_name:  'id',
        attribute_value: project_id,
        collection_name: 'projects',
        primary_key:     true
      )
    end

    define_method :call_command do
      command.call(attributes: matched_attributes)
    end

    it 'should return a failing result' do
      expect(call_command)
        .to be_a_failing_result
        .with_error(expected_error)
    end
  end

  describe 'with project_id: invalid slug' do
    let(:project_id) { 'invalid-task' }
    let(:matched_attributes) do
      valid_attributes.merge('project_id' => project_id)
    end
    let(:expected_error) do
      Cuprum::Collections::Errors::NotFound.new(
        attribute_name:  'slug',
        attribute_value: project_id,
        collection_name: 'projects',
        primary_key:     false
      )
    end

    define_method :call_command do
      command.call(attributes: matched_attributes)
    end

    it 'should return a failing result' do
      expect(call_command)
        .to be_a_failing_result
        .with_error(expected_error)
    end
  end

  describe 'with project_id: valid id' do
    let(:project) do
      attributes = Spec::Support::Fixtures::PROJECTS_FIXTURES.find do |item|
        item['id'] == valid_project_id
      end

      Project.new(**attributes)
    end
    let(:project_id)             { project['id'] }
    let(:empty_attributes)       { super().merge('project_id' => project_id) }
    let(:invalid_attributes)     { super().merge('project_id' => project_id) }
    let(:valid_attributes)       { super().merge('project_id' => project_id) }
    let(:expected_project_index) { 0 }
    let(:calculated_slug) do
      "#{project['slug']}-#{expected_project_index}"
    end

    before(:example) { insert('projects', project) }

    include_deferred 'should implement the New command',
      default_contract: true \
    do
      describe 'with slug: nil' do
        let(:matched_attributes) do
          configured_valid_attributes.merge('slug' => nil)
        end

        include_deferred 'should build the entity'
      end

      describe 'with slug: an empty String' do
        let(:matched_attributes) do
          configured_valid_attributes.merge('slug' => '')
        end

        include_deferred 'should build the entity'
      end

      describe 'with slug: value' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:slug) { 'custom-slug' }
        let(:matched_attributes) do
          configured_valid_attributes.merge('slug' => slug)
        end
        let(:expected_attributes) do
          super().merge('slug' => slug)
        end

        include_deferred 'should build the entity'
      end

      wrap_deferred 'when the collection has many items' do
        let(:expected_project_index) do
          fixtures_data
            .select { |task| task['project_id'] == project['id'] }
            .count
        end
        let(:matched_attributes) { configured_valid_attributes }

        include_deferred 'should build the entity'
      end
    end
  end

  describe 'with project_id: valid slug' do
    let(:project) do
      attributes = Spec::Support::Fixtures::PROJECTS_FIXTURES.find do |item|
        item['id'] == valid_project_id
      end

      Project.new(**attributes)
    end
    let(:project_id)             { project['slug'] }
    let(:empty_attributes)       { super().merge('project_id' => project_id) }
    let(:invalid_attributes)     { super().merge('project_id' => project_id) }
    let(:valid_attributes)       { super().merge('project_id' => project_id) }
    let(:expected_project_index) { 0 }
    let(:calculated_slug) do
      "#{project['slug']}-#{expected_project_index}"
    end
    let(:expected_attributes) { super().merge('project_id' => project.id) }

    before(:example) { insert('projects', project) }

    include_deferred 'should implement the New command',
      default_contract: true \
    do
      describe 'with slug: nil' do
        let(:matched_attributes) do
          configured_valid_attributes.merge('slug' => nil)
        end

        include_deferred 'should build the entity'
      end

      describe 'with slug: an empty String' do
        let(:matched_attributes) do
          configured_valid_attributes.merge('slug' => '')
        end

        include_deferred 'should build the entity'
      end

      describe 'with slug: value' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:slug) { 'custom-slug' }
        let(:matched_attributes) do
          configured_valid_attributes.merge('slug' => slug)
        end
        let(:expected_attributes) do
          super().merge('slug' => slug)
        end

        include_deferred 'should build the entity'
      end

      wrap_deferred 'when the collection has many items' do
        let(:expected_project_index) do
          fixtures_data
            .select { |task| task['project_id'] == project['id'] }
            .count
        end
        let(:matched_attributes) { configured_valid_attributes }

        include_deferred 'should build the entity'
      end
    end
  end
end
