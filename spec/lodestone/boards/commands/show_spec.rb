# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/records/repository'

RSpec.describe Lodestone::Boards::Commands::Show do
  subject(:command) { described_class.new(repository:) }

  let(:repository) { Cuprum::Rails::Records::Repository.new }

  describe '#call' do
    shared_context 'when there are many projects' do
      let(:project)       { FactoryBot.build(:project) }
      let(:other_project) { FactoryBot.build(:project) }

      before(:example) do
        [project, other_project].each do |entity|
          result =
            repository
            .find_or_create(entity_class: Project)
            .insert_one
            .call(entity:)

          raise result.error.message if result.failure?
        end
      end
    end

    shared_context 'when there are many tasks' do
      include_context 'when there are many projects'

      let(:project_tasks) do
        [
          FactoryBot.build(
            :task,
            :done,
            project:,
            updated_at: 6.days.ago
          ),
          FactoryBot.build(
            :task,
            :in_progress,
            project:,
            updated_at: 4.days.ago
          ),
          FactoryBot.build(
            :task,
            :to_do,
            project:,
            updated_at: 2.days.ago
          )
        ]
      end
      let(:other_project_tasks) do
        [
          FactoryBot.build(
            :task,
            :archived,
            project:    other_project,
            updated_at: 5.days.ago
          ),
          FactoryBot.build(
            :task,
            :in_progress,
            project:    other_project,
            updated_at: 3.days.ago
          ),
          FactoryBot.build(
            :task,
            :to_do,
            project:    other_project,
            updated_at: 1.day.ago
          )
        ]
      end
      let(:expected_tasks) do
        repository
          .find_or_create(entity_class: Task)
          .find_matching
          .call(order: { updated_at: :desc })
          .value
          .group_by(&:status)
      end

      before(:example) do
        [*project_tasks, *other_project_tasks].each do |entity|
          result =
            repository
            .find_or_create(entity_class: Task)
            .insert_one
            .call(entity:)

          raise result.error.message if result.failure?
        end
      end
    end

    let(:expected_tasks) { {} }
    let(:expected_value) do
      { 'project' => nil, 'tasks' => expected_tasks }
    end

    it 'should define the method' do
      expect(command)
        .to be_callable
        .with(0).arguments
        .and_keywords(:project_id)
        .and_any_keywords
    end

    it 'should return a passing result' do
      expect(command.call)
        .to be_a_passing_result
        .with_value(expected_value)
    end

    wrap_context 'when there are many tasks' do
      it 'should return a passing result' do
        expect(command.call)
          .to be_a_passing_result
          .with_value(expected_value)
      end
    end

    describe 'with project_id: nil' do
      let(:project_id) { nil }

      it 'should return a passing result' do
        expect(command.call(project_id:))
          .to be_a_passing_result
          .with_value(expected_value)
      end

      wrap_context 'when there are many tasks' do
        it 'should return a passing result' do
          expect(command.call(project_id:))
            .to be_a_passing_result
            .with_value(expected_value)
        end
      end
    end

    describe 'with project_id: an Object' do
      let(:project_id) { Object.new.freeze }
      let(:expected_error) do
        Cuprum::Errors::InvalidParameters.new(
          command_class: described_class,
          failures:      ['project_id must be a valid id or slug']
        )
      end

      it 'should return a failing result' do
        expect(command.call(project_id:))
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    describe 'with project_id: an empty String' do
      let(:project_id) { '' }
      let(:expected_error) do
        Cuprum::Errors::InvalidParameters.new(
          command_class: described_class,
          failures:      ['project_id must be a valid id or slug']
        )
      end

      it 'should return a failing result' do
        expect(command.call(project_id:))
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    describe 'with project_id: an invalid primary key' do
      let(:project_id) { SecureRandom.uuid }
      let(:expected_error) do
        Cuprum::Collections::Errors::NotFound.new(
          attribute_name:  'id',
          attribute_value: project_id,
          collection_name: 'projects',
          primary_key:     true
        )
      end

      it 'should return a failing result' do
        expect(command.call(project_id:))
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    describe 'with project_id: an invalid slug' do
      let(:project_id) { 'not-a-valid-project-slug' }
      let(:expected_error) do
        Cuprum::Collections::Errors::NotFound.new(
          attribute_name:  'slug',
          attribute_value: project_id,
          collection_name: 'projects',
          primary_key:     false
        )
      end

      it 'should return a failing result' do
        expect(command.call(project_id:))
          .to be_a_failing_result
          .with_error(expected_error)
      end
    end

    describe 'with project_id: a valid primary key' do
      include_context 'when there are many projects'

      let(:project_id) { project.id }
      let(:expected_value) { super().merge('project' => project) }

      it 'should return a passing result' do
        expect(command.call(project_id:))
          .to be_a_passing_result
          .with_value(expected_value)
      end

      wrap_context 'when there are many tasks' do
        let(:expected_tasks) do
          repository
            .find_or_create(entity_class: Task)
            .find_matching
            .call(
              order: { updated_at: :desc },
              where: { project_id: project.id }
            )
            .value
            .group_by(&:status)
        end

        it 'should return a passing result' do
          expect(command.call(project_id:))
            .to be_a_passing_result
            .with_value(expected_value)
        end
      end
    end

    describe 'with project_id: a valid slug' do
      include_context 'when there are many projects'

      let(:project_id) { project.slug }
      let(:expected_value) { super().merge('project' => project) }

      it 'should return a passing result' do
        expect(command.call(project_id:))
          .to be_a_passing_result
          .with_value(expected_value)
      end

      wrap_context 'when there are many tasks' do
        let(:expected_tasks) do
          repository
            .find_or_create(entity_class: Task)
            .find_matching
            .call(
              order: { updated_at: :desc },
              where: { project_id: project.id }
            )
            .value
            .group_by(&:status)
        end

        it 'should return a passing result' do
          expect(command.call(project_id:))
            .to be_a_passing_result
            .with_value(expected_value)
        end
      end
    end
  end
end
