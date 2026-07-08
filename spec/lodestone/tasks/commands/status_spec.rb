# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/rspec/deferred/commands/resources_examples'

require 'support/examples/commands/tasks_examples'

RSpec.describe Lodestone::Tasks::Commands::Status do
  include Cuprum::Rails::RSpec::Deferred::Commands::ResourcesExamples
  include Spec::Support::Examples::Commands::TasksExamples

  subject(:command) { described_class.new(repository:, resource:) }

  let(:expected_attributes) do
    original_attributes
      .merge(tools.hash_tools.convert_keys_to_strings(matched_attributes))
      .merge('id' => be_a_uuid)
  end

  deferred_examples 'should not update the entity' do
    it { expect { call_command }.not_to(change { persisted_data }) }
  end

  deferred_examples 'should update the entity' do
    let(:entity_class) { collection.entity_class }
    let(:expected_value) do
      next super() if defined?(super())

      be_a_record(entity_class).with_attributes(expected_attributes)
    end
    let(:persisted_value) do
      next super() if defined?(super())

      expected_value
    end

    define_method :match_expected_value do
      # :nocov:
      return expected_value if expected_value.respond_to?(:matches?)

      match(expected_value)
      # :nocov:
    end

    it 'should return a passing result', :aggregate_failures do
      result = call_command

      expect(result).to be_a_passing_result
      expect(result.value).to match_expected_value
    end

    it { expect { call_command }.not_to(change { persisted_data.count }) } # rubocop:disable RSpec/ExpectChange

    it 'should update the entity in the collection' do # rubocop:disable RSpec/ExampleLength
      entity = matched_entity

      call_command

      primary_key    = entity[resource.primary_key_name]
      updated_entity = persisted_data.find do |updated|
        updated[resource.primary_key_name] == primary_key
      end

      expect(updated_entity).to match(persisted_value)
    end
  end

  define_method :persisted_data do
    return super() if defined?(super())

    collection
      .find_matching
      .call
      .value
      .to_a
  end

  include_deferred 'with parameters for a Task command'

  describe '#call' do
    let(:matched_attributes) { {} }

    define_method(:call_command) do
      return super() if defined?(super())

      command.call(
        attributes:  matched_attributes,
        entity:,
        primary_key:
      )
    end

    define_method(:tools) do
      SleepingKingStudios::Tools::Toolbelt.instance
    end

    include_deferred 'when the collection is defined'

    it 'should define the method' do
      expect(command)
        .to be_callable
        .with(0).arguments
        .and_keywords(:attributes, :entity, :primary_key)
        .and_any_keywords
    end

    include_deferred 'should require entity'

    wrap_deferred 'when the collection has many items' do
      include_deferred 'with a valid entity' do
        let!(:original_attributes) do # rubocop:disable RSpec/LetSetup
          next super() if defined?(super())

          value = matched_entity

          value.is_a?(Hash) ? value : value.attributes
        end

        describe 'with attributes: an empty Hash' do
          let(:matched_attributes) { {} }

          include_deferred 'should not update the entity'
        end

        describe 'with attributes: an Hash with invalid attributes' do
          let(:matched_attributes) { { 'status' => 'invalid' } }
          let(:expected_error) do
            entity = matched_entity
            entity =
              collection
              .assign_one
              .call(attributes: matched_attributes, entity:)
              .value

            result = collection.validate_one.call(entity:)

            Cuprum::Collections::Errors::FailedValidation.new(
              entity_class: Task,
              errors:       result.error&.errors
            )
          end

          include_deferred 'should validate the entity'

          include_deferred 'should not update the entity'
        end

        describe 'with attributes: a Hash with String keys' do
          let(:matched_attributes) do
            { 'status' => Task::Statuses::ARCHIVED }
          end

          include_deferred 'should update the entity'
        end

        describe 'with attributes: a Hash with Symbol keys' do
          let(:matched_attributes) do
            { status: Task::Statuses::ARCHIVED }
          end

          include_deferred 'should update the entity'
        end
      end

      describe 'with primary_key: an invalid slug' do
        let(:invalid_primary_key_value) do
          'invalid-task'
        end
        let(:entity)      { nil }
        let(:primary_key) { invalid_primary_key_value }
        let(:expected_error) do
          Cuprum::Collections::Errors::NotFound.new(
            attribute_name:  'slug',
            attribute_value: invalid_primary_key_value,
            name:            resource.name,
            primary_key:     false
          )
        end

        it 'should return a failing result' do
          expect(call_command)
            .to be_a_failing_result
            .with_error(expected_error)
        end
      end

      describe 'with primary_key: a valid slug' do
        let(:valid_primary_key_value) do
          collection_data.first['slug']
        end
        let(:matched_entity) do
          collection
            .find_matching
            .call(where: { slug: valid_primary_key_value })
            .value
            .first
        end
        let(:original_attributes) do
          matched_entity.attributes
        end
        let(:matched_attributes) do
          { status: Task::Statuses::ARCHIVED }
        end
        let(:entity)      { nil }
        let(:primary_key) { matched_entity['slug'] }

        include_deferred 'should update the entity'
      end
    end
  end
end
