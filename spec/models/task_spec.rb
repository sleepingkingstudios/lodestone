# frozen_string_literal: true

require 'rails_helper'

require 'support/examples/model_examples'

RSpec.describe Task, type: :model do
  include Spec::Support::Examples::ModelExamples

  shared_context 'when the task has a project' do
    let(:attributes) { super().merge(project: project) }

    before(:example) { project.save! }
  end

  subject(:task) { described_class.new(attributes) }

  let(:project) { FactoryBot.build(:project, name: 'Xanadu') }
  let(:attributes) do
    {
      title:         'Implement Example Feature',
      description:   'Implement the example feature.',
      project_index: 0,
      slug:          'xanadu-0',
      status:        described_class::Statuses::IN_PROGRESS,
      task_type:     described_class::TaskTypes::INVESTIGATION
    }
  end

  describe '::Statuses' do
    let(:expected_statuses) do
      {
        DONE:        'done',
        ICEBOX:      'icebox',
        IN_PROGRESS: 'in_progress',
        TODO:        'todo'
      }
    end

    include_examples 'should define immutable constant', :Statuses

    it 'should enumerate the statuses' do
      expect(described_class::Statuses.all).to be == expected_statuses
    end

    describe '::DONE' do
      it 'should store the value' do
        expect(described_class::Statuses::DONE)
          .to be == 'done'
      end
    end

    describe '::ICEBOX' do
      it 'should store the value' do
        expect(described_class::Statuses::ICEBOX)
          .to be == 'icebox'
      end
    end

    describe '::IN_PROGRESS' do
      it 'should store the value' do
        expect(described_class::Statuses::IN_PROGRESS)
          .to be == 'in_progress'
      end
    end

    describe '::TODO' do
      it 'should store the value' do
        expect(described_class::Statuses::TODO)
          .to be == 'todo'
      end
    end
  end

  describe '::TaskTypes' do
    let(:expected_types) do
      {
        BUGFIX:        'bugfix',
        CHORE:         'chore',
        FEATURE:       'feature',
        INVESTIGATION: 'investigation',
        RELEASE:       'release'
      }
    end

    include_examples 'should define immutable constant', :TaskTypes

    it 'should enumerate the types' do
      expect(described_class::TaskTypes.all).to be == expected_types
    end

    describe '::BUGFIX' do
      it 'should store the value' do
        expect(described_class::TaskTypes::BUGFIX)
          .to be == 'bugfix'
      end
    end

    describe '::CHORE' do
      it 'should store the value' do
        expect(described_class::TaskTypes::CHORE)
          .to be == 'chore'
      end
    end

    describe '::FEATURE' do
      it 'should store the value' do
        expect(described_class::TaskTypes::FEATURE)
          .to be == 'feature'
      end
    end

    describe '::INVESTIGATION' do
      it 'should store the value' do
        expect(described_class::TaskTypes::INVESTIGATION)
          .to be == 'investigation'
      end
    end

    describe '::RELEASE' do
      it 'should store the value' do
        expect(described_class::TaskTypes::RELEASE)
          .to be == 'release'
      end
    end
  end

  include_examples 'should define primary key'

  include_examples 'should define slug',
    other_attributes: -> { { project: project.tap(&:save!) } }

  include_examples 'should define timestamps'

  describe '#description' do
    include_examples 'should define attribute', :description, default: ''
  end

  describe '#project' do
    include_examples 'should define property', :project, nil

    wrap_context 'when the task has a project' do
      it { expect(task.project).to be == project }
    end
  end

  describe '#project_id' do
    include_examples 'should define attribute',
      :project_id,
      value: -> { project.id }

    wrap_context 'when the task has a project' do
      it { expect(task.project_id).to be == project.id }
    end
  end

  describe '#project_index' do
    include_examples 'should define attribute', :project_index
  end

  describe '#status' do
    include_examples 'should define attribute',
      :status,
      default: described_class::Statuses::ICEBOX
  end

  describe '#task_type' do
    include_examples 'should define attribute',
      :task_type,
      default: described_class::TaskTypes::FEATURE
  end

  describe '#title' do
    include_examples 'should define attribute', :title, default: ''
  end

  describe '#valid?' do
    wrap_context 'when the task has a project' do
      it { expect(task).not_to have_errors }
    end

    include_examples 'should validate the presence of',
      :description,
      type: String

    include_examples 'should validate the numericality of',
      :project_index,
      greater_than_or_equal_to: 0,
      only_integer:             true

    include_examples 'should validate the presence of', :project_index

    include_examples 'should validate the scoped uniqueness of',
      :project_index,
      attributes: {
        title:       'Fix Example Bug',
        slug:        'xanadu-1',
        description: 'Fix the example bug'
      },
      scope:      {
        project: [
          -> { project },
          -> { FactoryBot.create(:project, name: 'Shangri-La') }
        ]
      }

    include_examples 'should validate the presence of', :status, type: String

    include_examples 'should validate the inclusion of',
      :status,
      in: described_class::Statuses.values

    include_examples 'should validate the presence of', :task_type, type: String

    include_examples 'should validate the inclusion of',
      :task_type,
      in: described_class::TaskTypes.values

    include_examples 'should validate the presence of', :title, type: String
  end
end
