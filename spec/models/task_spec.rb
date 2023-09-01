# frozen_string_literal: true

require 'rails_helper'

require 'support/examples/model_examples'

RSpec.describe Task, type: :model do
  include Spec::Support::Examples::ModelExamples

  subject(:task) { described_class.new(attributes) }

  shared_context 'when the task has a project' do
    let(:attributes) { super().merge(project: project) }

    before(:example) { project.save! }
  end

  shared_context 'when the task has relationships' do
    include_context 'when the task has a project'

    let(:other_task) { FactoryBot.build(:task, project: project) }
    let(:inverse_relationships) do
      Array.new(3) do
        FactoryBot.build(
          :task_relationship,
          source_task: other_task,
          target_task: task
        )
      end
    end
    let(:relationships) do
      Array.new(3) do
        FactoryBot.build(
          :task_relationship,
          source_task: task,
          target_task: other_task
        )
      end
    end

    before(:example) do
      other_task.save!

      relationships.each(&:save!)
    end
  end

  let(:project) { FactoryBot.build(:project, name: 'Xanadu') }
  let(:attributes) do
    {
      title:         'Implement Example Feature',
      description:   'Implement the example feature.',
      project_index: 0,
      slug:          'xanadu-0',
      status:        described_class::Statuses::IN_PROGRESS.key,
      task_type:     described_class::TaskTypes::INVESTIGATION
    }
  end

  describe '::Status' do
    subject(:status) { described_class::Status.new('dazed', 'confused') }

    include_examples 'should define constant',
      :Status,
      -> { an_instance_of Class }

    describe '#key' do
      include_examples 'should define reader', :key, 'dazed'
    end

    describe '#name' do
      include_examples 'should define reader', :name, 'confused'
    end
  end

  describe '::Statuses' do
    let(:expected_keys) { %i[WONT_DO ICEBOX TO_DO IN_PROGRESS DONE ARCHIVED] }

    include_examples 'should define immutable constant', :Statuses

    it 'should enumerate the status keys' do
      expect(described_class::Statuses.keys).to be == expected_keys
    end

    describe '::ARCHIVED' do
      let(:expected_attributes) { { key: 'archived', name: 'archived' } }

      it 'should store the status' do
        expect(described_class::Statuses::ARCHIVED)
          .to be_a(described_class::Status)
          .and(have_attributes(expected_attributes))
      end
    end

    describe '::DONE' do
      let(:expected_attributes) { { key: 'done', name: 'done' } }

      it 'should store the status' do
        expect(described_class::Statuses::DONE)
          .to be_a(described_class::Status)
          .and(have_attributes(expected_attributes))
      end
    end

    describe '::ICEBOX' do
      let(:expected_attributes) { { key: 'icebox', name: 'icebox' } }

      it 'should store the status' do
        expect(described_class::Statuses::ICEBOX)
          .to be_a(described_class::Status)
          .and(have_attributes(expected_attributes))
      end
    end

    describe '::IN_PROGRESS' do
      let(:expected_attributes) { { key: 'in_progress', name: 'in progress' } }

      it 'should store the status' do
        expect(described_class::Statuses::IN_PROGRESS)
          .to be_a(described_class::Status)
          .and(have_attributes(expected_attributes))
      end
    end

    describe '::TO_DO' do
      let(:expected_attributes) { { key: 'to_do', name: 'to do' } }

      it 'should store the status' do
        expect(described_class::Statuses::TO_DO)
          .to be_a(described_class::Status)
          .and(have_attributes(expected_attributes))
      end
    end

    describe '::WONT_DO' do
      let(:expected_attributes) { { key: 'wont_do', name: "won't do" } }

      it 'should store the status' do
        expect(described_class::Statuses::WONT_DO)
          .to be_a(described_class::Status)
          .and(have_attributes(expected_attributes))
      end
    end
  end

  describe '::TaskTypes' do
    let(:expected_types) do
      {
        BUGFIX:        'bugfix',
        CHORE:         'chore',
        EPIC:          'epic',
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

    describe '::EPIC' do
      it 'should store the value' do
        expect(described_class::TaskTypes::EPIC)
          .to be == 'epic'
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

  describe '#bugfix?' do
    include_examples 'should define predicate', :bugfix?

    described_class::TaskTypes.each_value do |task_type|
      context %(when the task type is "#{task_type}") do
        let(:expected) do
          task.task_type == described_class::TaskTypes::BUGFIX
        end

        it { expect(task.bugfix?).to be expected }
      end
    end
  end

  describe '#chore?' do
    include_examples 'should define predicate', :chore?

    described_class::TaskTypes.each_value do |task_type|
      context %(when the task type is "#{task_type}") do
        let(:expected) do
          task.task_type == described_class::TaskTypes::CHORE
        end

        it { expect(task.chore?).to be expected }
      end
    end
  end

  describe '#description' do
    include_examples 'should define attribute', :description, default: ''
  end

  describe '#epic?' do
    include_examples 'should define predicate', :epic?

    described_class::TaskTypes.each_value do |task_type|
      context %(when the task type is "#{task_type}") do
        let(:expected) do
          task.task_type == described_class::TaskTypes::EPIC
        end

        it { expect(task.epic?).to be expected }
      end
    end
  end

  describe '#feature?' do
    include_examples 'should define predicate', :feature?

    described_class::TaskTypes.each_value do |task_type|
      context %(when the task type is "#{task_type}") do
        let(:expected) do
          task.task_type == described_class::TaskTypes::FEATURE
        end

        it { expect(task.feature?).to be expected }
      end
    end
  end

  describe '#inverse_relationships' do
    include_examples 'should define reader', :inverse_relationships, []

    wrap_context 'when the task has relationships' do
      let(:expected) { inverse_relationships }

      it { expect(task.inverse_relationships).to match_array(expected) }
    end
  end

  describe '#investigation?' do
    include_examples 'should define predicate', :investigation?

    described_class::TaskTypes.each_value do |task_type|
      context %(when the task type is "#{task_type}") do
        let(:expected) do
          task.task_type == described_class::TaskTypes::INVESTIGATION
        end

        it { expect(task.investigation?).to be expected }
      end
    end
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

  describe '#relationships' do
    include_examples 'should define reader', :relationships, []

    wrap_context 'when the task has relationships' do
      it { expect(task.relationships).to match_array(relationships) }
    end
  end

  describe '#release?' do
    include_examples 'should define predicate', :release?

    described_class::TaskTypes.each_value do |task_type|
      context %(when the task type is "#{task_type}") do
        let(:expected) do
          task.task_type == described_class::TaskTypes::RELEASE
        end

        it { expect(task.release?).to be expected }
      end
    end
  end

  describe '#status' do
    include_examples 'should define attribute',
      :status,
      default: described_class::Statuses::ICEBOX.key
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

    include_examples 'should validate the presence of',
      :project,
      message: 'must exist'

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
      in: described_class::Statuses.values.map(&:key)

    include_examples 'should validate the presence of', :task_type, type: String

    include_examples 'should validate the inclusion of',
      :task_type,
      in: described_class::TaskTypes.values

    include_examples 'should validate the presence of', :title, type: String
  end
end
