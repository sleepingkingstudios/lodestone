# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/records/repository'
require 'cuprum/rails/request'

RSpec.describe Lodestone::TaskRelationships::Middleware::FindTasks do
  subject(:middleware) { described_class.new }

  describe '#call' do
    shared_context 'with a valid task' do
      let(:source_project) do
        FactoryBot.build(:project, name: 'Source Project')
      end
      let(:source_task) do
        FactoryBot.build(:task, project: source_project)
      end

      before(:example) do
        insert('projects', source_project)
        insert('tasks',    source_task)
      end
    end

    shared_context 'when the project has many tasks' do
      let(:source_project_tasks) do
        [
          FactoryBot.build(
            :task,
            project:    source_project,
            title:      '2 Days Ago',
            created_at: 2.days.ago
          ),
          FactoryBot.build(
            :task,
            project:    source_project,
            title:      '1 Day Ago',
            created_at: 1.day.ago
          ),
          FactoryBot.build(
            :task,
            project:    source_project,
            title:      '3 Days Ago',
            created_at: 3.days.ago
          )
        ]
      end

      before(:example) do
        source_project_tasks.each { |task| insert('tasks', task) }
      end
    end

    shared_context 'when there are many projects' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:other_project) do
        FactoryBot.build(:project, name: 'Other Project')
      end
      let(:other_project_tasks) do
        Array.new(2) { FactoryBot.build(:task, project: other_project) }
      end
      let(:third_project) do
        FactoryBot.build(:project, name: 'Third Project')
      end
      let(:third_project_tasks) do
        Array.new(2) { FactoryBot.build(:task, project: third_project) }
      end

      before(:example) do
        insert('projects', other_project)
        insert('projects', third_project)

        other_project_tasks.each { |task| insert('tasks', task) }
        third_project_tasks.each { |task| insert('tasks', task) }
      end
    end

    shared_examples 'should call the next command' do
      let(:expected_params) do
        next params unless defined?(source_task)

        relationship_params =
          params
          .fetch('task_relationship', {})
          .merge('source_task_id' => source_task&.id)

        params.merge(
          'task_relationship' => relationship_params
        )
      end
      let(:expected_request) do
        be_a(Cuprum::Rails::Request).and have_attributes(
          http_method:,
          params:      expected_params
        )
      end

      it 'should call the next command' do # rubocop:disable RSpec/ExampleLength
        call_command

        expect(next_command)
          .to have_received(:call)
          .with(
            repository:,
            request:    expected_request,
            **options
          )
      end

      context 'when called with task relationship parameters' do
        let(:params) do
          super().merge(
            'task_relationship' => { 'relationship_type' => 'depends_on' }
          )
        end

        it 'should call the next command' do # rubocop:disable RSpec/ExampleLength
          call_command

          expect(next_command)
            .to have_received(:call)
            .with(
              repository:,
              request:    expected_request,
              **options
            )
        end
      end

      context 'when called with custom options' do
        let(:options) do
          super().merge('custom_option' => 'custom value')
        end

        it 'should call the next command' do # rubocop:disable RSpec/ExampleLength
          call_command

          expect(next_command)
            .to have_received(:call)
            .with(
              repository:,
              request:    expected_request,
              **options
            )
        end
      end
    end

    let(:next_value)   { { 'ok' => true } }
    let(:next_result)  { Cuprum::Result.new(value: next_value) }
    let(:next_command) { instance_double(Cuprum::Command, call: next_result) }
    let(:http_method)  { :get }
    let(:params)       { {} }
    let(:request)      { Cuprum::Rails::Request.new(http_method:, params:) }
    let(:options)      { {} }
    let(:repository) do
      Cuprum::Rails::Records::Repository.new.tap do |repository|
        repository.create(entity_class: Project)
        repository.create(entity_class: Task)
      end
    end

    define_method(:insert) do |collection_name, *entities|
      entities.each do |entity|
        result = repository[collection_name].insert_one.call(entity:)

        raise result.error.message if result.failure?
      end
    end

    define_method(:sort_tasks) do |tasks|
      tasks.sort { |u, v| v.created_at <=> u.created_at }
    end

    def call_command
      middleware.call(
        next_command,
        repository:,
        request:,
        **options
      )
    end

    it 'should define the method' do
      expect(middleware)
        .to be_callable
        .with(1).argument
        .and_keywords(:repository, :request)
        .and_any_keywords
    end

    describe 'with task_id: nil' do
      it 'should return a passing result' do
        expect(call_command)
          .to be_a_passing_result
          .with_value(next_value)
      end

      include_examples 'should call the next command'
    end

    describe 'with task_id: an invalid id' do
      let(:task_id) { SecureRandom.uuid }
      let(:params)  { super().merge('task_id' => task_id) }
      let(:expected_error) do
        Cuprum::Collections::Errors::NotFound.new(
          attribute_name:  'id',
          attribute_value: task_id,
          collection_name: 'tasks',
          primary_key:     true
        )
      end

      it 'should return a failing result' do
        expect(call_command)
          .to be_a_failing_result
          .with_error(expected_error)
      end

      it 'should not call the next command' do
        call_command

        expect(next_command).not_to have_received(:call)
      end
    end

    describe 'with task_id: an invalid slug' do
      let(:task_id) { 'invalid-slug' }
      let(:params)  { super().merge('task_id' => task_id) }
      let(:expected_error) do
        Cuprum::Collections::Errors::NotFound.new(
          attribute_name:  'slug',
          attribute_value: task_id,
          collection_name: 'tasks',
          primary_key:     false
        )
      end

      it 'should return a failing result' do
        expect(call_command)
          .to be_a_failing_result
          .with_error(expected_error)
      end

      it 'should not call the next command' do
        call_command

        expect(next_command).not_to have_received(:call)
      end
    end

    # rubocop:disable RSpec/MultipleMemoizedHelpers
    describe 'with task_id: a valid id' do
      include_context 'with a valid task'

      let(:task_id)        { source_task.id }
      let(:params)         { super().merge('task_id' => task_id) }
      let(:expected_tasks) { {} }
      let(:expected_value) do
        next_value.merge(
          'source_task' => source_task,
          'tasks'       => expected_tasks
        )
      end

      it 'should return a passing result' do
        expect(call_command)
          .to be_a_passing_result
          .with_value(expected_value)
      end

      include_examples 'should call the next command'

      wrap_context 'when the project has many tasks' do
        let(:expected_tasks) do
          super().merge(
            source_project.name => sort_tasks(source_project_tasks)
          )
        end

        it 'should return a passing result' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(expected_value)
        end
      end

      wrap_context 'when there are many projects' do
        let(:expected_tasks) do
          super().merge(
            other_project.name => sort_tasks(other_project_tasks),
            third_project.name => sort_tasks(third_project_tasks)
          )
        end

        it 'should return a passing result' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(expected_value)
        end
      end

      context 'when there are many tasks and projects' do
        include_context 'when the project has many tasks'
        include_context 'when there are many projects'

        let(:expected_tasks) do
          super().merge(
            source_project.name => sort_tasks(source_project_tasks),
            other_project.name  => sort_tasks(other_project_tasks),
            third_project.name  => sort_tasks(third_project_tasks)
          )
        end

        it 'should return a passing result' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(expected_value)
        end
      end

      context 'with a failing non-GET request' do
        let(:http_method) { :post }
        let(:next_result) do
          Cuprum::Result.new(status: :failure, value: next_value)
        end

        it 'should return a failing result' do
          expect(call_command)
            .to be_a_failing_result
            .with_value(expected_value)
        end

        include_examples 'should call the next command'
      end

      context 'with a passing non-GET request' do
        let(:http_method)    { :post }
        let(:expected_value) { next_value }

        it 'should return a passing result' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(expected_value)
        end

        include_examples 'should call the next command'
      end
    end

    describe 'with task_id: a valid slug' do
      include_context 'with a valid task'

      let(:task_id)        { source_task.slug }
      let(:params)         { super().merge('task_id' => task_id) }
      let(:expected_tasks) { {} }
      let(:expected_value) do
        next_value.merge(
          'source_task' => source_task,
          'tasks'       => expected_tasks
        )
      end

      it 'should return a passing result' do
        expect(call_command)
          .to be_a_passing_result
          .with_value(expected_value)
      end

      include_examples 'should call the next command'

      wrap_context 'when the project has many tasks' do
        let(:expected_tasks) do
          super().merge(
            source_project.name => sort_tasks(source_project_tasks)
          )
        end

        it 'should return a passing result' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(expected_value)
        end
      end

      wrap_context 'when there are many projects' do
        let(:expected_tasks) do
          super().merge(
            other_project.name => sort_tasks(other_project_tasks),
            third_project.name => sort_tasks(third_project_tasks)
          )
        end

        it 'should return a passing result' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(expected_value)
        end
      end

      context 'when there are many tasks and projects' do
        include_context 'when the project has many tasks'
        include_context 'when there are many projects'

        let(:expected_tasks) do
          super().merge(
            source_project.name => sort_tasks(source_project_tasks),
            other_project.name  => sort_tasks(other_project_tasks),
            third_project.name  => sort_tasks(third_project_tasks)
          )
        end

        it 'should return a passing result' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(expected_value)
        end
      end

      context 'with a failing non-GET request' do
        let(:http_method) { :post }
        let(:next_result) do
          Cuprum::Result.new(status: :failure, value: next_value)
        end

        it 'should return a failing result' do
          expect(call_command)
            .to be_a_failing_result
            .with_value(expected_value)
        end

        include_examples 'should call the next command'
      end

      context 'with a passing non-GET request' do
        let(:http_method)    { :post }
        let(:expected_value) { next_value }

        it 'should return a passing result' do
          expect(call_command)
            .to be_a_passing_result
            .with_value(expected_value)
        end

        include_examples 'should call the next command'
      end
    end
    # rubocop:enable RSpec/MultipleMemoizedHelpers
  end
end
