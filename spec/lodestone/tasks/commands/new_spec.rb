# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/rspec/deferred/commands/resources/new_examples'

require 'support/examples/commands/tasks_examples'

RSpec.describe Lodestone::Tasks::Commands::New do
  include Cuprum::Rails::RSpec::Deferred::Commands::Resources::NewExamples
  include Spec::Support::Examples::Commands::TasksExamples

  subject(:command) { described_class.new(repository:, resource:) }

  let(:expected_slug) do
    matched = tools.hash_tools.convert_keys_to_strings(matched_attributes)

    next matched['slug'] if matched['slug'].present?

    next if matched['project'].blank?

    "#{matched['project']['slug']}-#{expected_project_index}"
  end
  let(:expected_project_index) do
    project_id =
      matched_attributes.fetch('project_id') { matched_attributes[:project_id] }

    project_id.present? ? 0 : nil
  end
  let(:expected_attributes) do
    empty_attributes
      .merge(tools.hash_tools.convert_keys_to_strings(matched_attributes))
      .merge(
        'id'            => be_a_uuid,
        'slug'          => expected_slug,
        'project_index' => expected_project_index
      )
  end

  include_deferred 'with parameters for a Task command'

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
