# frozen_string_literal: true

# == Schema Information
#
# Table name: task_relationships
#
#  id                :uuid             not null, primary key
#  relationship_type :string           default("depends_on"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  source_task_id    :uuid
#  target_task_id    :uuid
#
# Indexes
#
#  index_task_relationships_on_source_task_id  (source_task_id)
#  index_task_relationships_on_target_task_id  (target_task_id)
#
# Foreign Keys
#
#  fk_rails_...  (source_task_id => tasks.id)
#  fk_rails_...  (target_task_id => tasks.id)
#
require 'rails_helper'

require 'support/examples/model_examples'

RSpec.describe TaskRelationship, type: :model do
  include Spec::Support::Examples::ModelExamples

  subject(:relationship) { described_class.new(attributes) }

  shared_context 'when the relationship has a source task' do
    let(:project)     { FactoryBot.build(:project) }
    let(:source_task) { FactoryBot.build(:task, project: project) }

    before(:example) do
      project.save!
      source_task.save!

      attributes[:source_task] = source_task
    end
  end

  shared_context 'when the relationship has a target task' do
    let(:project)     { FactoryBot.build(:project) }
    let(:target_task) { FactoryBot.build(:task, project: project) }

    before(:example) do
      project.save!
      target_task.save!

      attributes[:target_task] = target_task
    end
  end

  shared_context 'when the relationship has source and target tasks' do
    include_context 'when the relationship has a source task'
    include_context 'when the relationship has a target task'
  end

  let(:attributes) do
    {
      relationship_type: described_class::RelationshipTypes::DEPENDS_ON.key
    }
  end

  describe '::RelationshipType' do
    subject(:relationship_type) do
      described_class::RelationshipType.new(
        key:          'testing',
        name:         'tests',
        inverse_name: 'tested by'
      )
    end

    include_examples 'should define constant',
      :RelationshipType,
      -> { an_instance_of Class }

    describe '#inverse_name' do
      include_examples 'should define reader', :inverse_name, 'tested by'
    end

    describe '#key' do
      include_examples 'should define reader', :key, 'testing'
    end

    describe '#name' do
      include_examples 'should define reader', :name, 'tests'
    end
  end

  describe '::RelationshipTypes' do
    let(:expected_keys) do
      %i[
        BELONGS_TO
        DEPENDS_ON
        MERGED_INTO
        RELATES_TO
      ]
    end

    include_examples 'should define immutable constant', :RelationshipTypes

    it 'should enumerate the type keys' do
      expect(described_class::RelationshipTypes.keys).to be == expected_keys
    end

    describe '::BELONGS_TO' do
      let(:expected_attributes) do
        {
          key:          'belongs_to',
          inverse_name: 'has child',
          name:         'belongs to'
        }
      end

      it 'should store the relationship type' do
        expect(described_class::RelationshipTypes::BELONGS_TO)
          .to be_a(described_class::RelationshipType)
          .and(have_attributes(expected_attributes))
      end
    end

    describe '::MERGED_INTO' do
      let(:expected_attributes) do
        {
          key:          'merged_into',
          inverse_name: 'merged from',
          name:         'merged into'
        }
      end

      it 'should store the relationship type' do
        expect(described_class::RelationshipTypes::MERGED_INTO)
          .to be_a(described_class::RelationshipType)
          .and(have_attributes(expected_attributes))
      end
    end

    describe '::DEPENDS_ON' do
      let(:expected_attributes) do
        {
          key:          'depends_on',
          inverse_name: 'dependency of',
          name:         'depends on'
        }
      end

      it 'should store the relationship type' do
        expect(described_class::RelationshipTypes::DEPENDS_ON)
          .to be_a(described_class::RelationshipType)
          .and(have_attributes(expected_attributes))
      end
    end

    describe '::RELATES_TO' do
      let(:expected_attributes) do
        {
          key:          'relates_to',
          inverse_name: 'related to',
          name:         'relates to'
        }
      end

      it 'should store the relationship type' do
        expect(described_class::RelationshipTypes::RELATES_TO)
          .to be_a(described_class::RelationshipType)
          .and(have_attributes(expected_attributes))
      end
    end
  end

  include_examples 'should define primary key'

  include_examples 'should define timestamps'

  describe '#relationship_type' do
    include_examples 'should define attribute',
      :relationship_type,
      default: described_class::RelationshipTypes::DEPENDS_ON.key
  end

  describe '#source_task' do
    include_examples 'should define property', :source_task, nil

    wrap_context 'when the relationship has a source task' do
      it { expect(relationship.source_task).to be source_task }
    end
  end

  describe '#source_task_id' do
    include_examples 'should define attribute', :source_task_id, value: nil

    wrap_context 'when the relationship has a source task' do
      it { expect(relationship.source_task_id).to be == source_task.id }
    end
  end

  describe '#target_task' do
    include_examples 'should define property', :target_task, nil

    wrap_context 'when the relationship has a target task' do
      it { expect(relationship.target_task).to be target_task }
    end
  end

  describe '#target_task_id' do
    include_examples 'should define attribute', :target_task_id, value: nil

    wrap_context 'when the relationship has a target task' do
      it { expect(relationship.target_task_id).to be == target_task.id }
    end
  end

  describe '#valid?' do
    wrap_context 'when the relationship has source and target tasks' do
      it { expect(relationship).not_to have_errors }

      context 'when the source and target tasks are identical' do
        let(:target_task) { source_task }

        it 'should add the error' do
          expect(relationship)
            .to have_errors
            .on(:target_task)
            .with_message('must not match source task')
        end
      end
    end

    include_examples 'should validate the presence of', :relationship_type

    include_examples 'should validate the inclusion of',
      :relationship_type,
      in: described_class::RelationshipTypes.values.map(&:key)

    include_examples 'should validate the presence of',
      :source_task,
      message: 'must exist'

    include_examples 'should validate the presence of',
      :target_task,
      message: 'must exist'
  end
end
