# frozen_string_literal: true

require 'rails_helper'

require 'support/examples/model_examples'

RSpec.describe TaskRelationship, type: :model do
  include Spec::Support::Examples::ModelExamples

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

  subject(:relationship) { described_class.new(attributes) }

  let(:attributes) do
    {
      blocking:          false,
      relationship_type: described_class::RelationshipTypes::DEPENDS_ON
    }
  end

  describe '::RelationshipTypes' do
    let(:expected_types) do
      {
        DEPENDS_ON: 'depends_on',
        RELATES_TO: 'relates_to'
      }
    end

    include_examples 'should define immutable constant', :RelationshipTypes

    it 'should enumerate the statuses' do
      expect(described_class::RelationshipTypes.all).to be == expected_types
    end

    describe '::DEPENDS_ON' do
      it 'should store the value' do
        expect(described_class::RelationshipTypes::DEPENDS_ON)
          .to be == 'depends_on'
      end
    end

    describe '::RELATES_TO' do
      it 'should store the value' do
        expect(described_class::RelationshipTypes::RELATES_TO)
          .to be == 'relates_to'
      end
    end
  end

  include_examples 'should define primary key'

  include_examples 'should define timestamps'

  describe '#blocking' do
    include_examples 'should define attribute', :blocking, default: false
  end

  describe '#relationship_type' do
    include_examples 'should define attribute',
      :relationship_type,
      default: described_class::RelationshipTypes::RELATES_TO
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

    include_examples 'should validate the presence of', :blocking

    include_examples 'should validate the presence of', :relationship_type

    include_examples 'should validate the inclusion of',
      :relationship_type,
      in: described_class::RelationshipTypes.values

    include_examples 'should validate the presence of',
      :source_task,
      message: 'must exist'

    include_examples 'should validate the presence of',
      :target_task,
      message: 'must exist'
  end
end
