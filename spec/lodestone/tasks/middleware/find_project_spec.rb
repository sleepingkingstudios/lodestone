# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/records/repository'
require 'cuprum/rails/request'

RSpec.describe Lodestone::Tasks::Middleware::FindProject do
  subject(:middleware) { described_class.new }

  describe '#call' do
    shared_examples 'should call the next command' do
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
    let(:params)       { {} }
    let(:request)      { Cuprum::Rails::Request.new(params:) }
    let(:options)      { {} }
    let(:repository) do
      Cuprum::Rails::Records::Repository.new.tap do |repository|
        repository.create(entity_class: Project)
      end
    end

    define_method(:insert) do |collection_name, *entities|
      entities.each do |entity|
        result = repository[collection_name].insert_one.call(entity:)

        raise result.error.message if result.failure?
      end
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

    describe 'with project_id: nil' do
      let(:expected_request) { request }

      it 'should return a passing result' do
        expect(call_command)
          .to be_a_passing_result
          .with_value(next_value)
      end

      include_examples 'should call the next command'
    end

    describe 'with project_id: an invalid id' do
      let(:project_id) { SecureRandom.uuid }
      let(:params)     { super().merge('project_id' => project_id) }
      let(:expected_error) do
        Cuprum::Collections::Errors::NotFound.new(
          attribute_name:  'id',
          attribute_value: project_id,
          collection_name: 'projects',
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

    describe 'with project_id: an invalid slug' do
      let(:project_id) { 'invalid-slug' }
      let(:params)     { super().merge('project_id' => project_id) }
      let(:expected_error) do
        Cuprum::Collections::Errors::NotFound.new(
          attribute_name:  'slug',
          attribute_value: project_id,
          collection_name: 'projects',
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

    describe 'with project_id: a valid id' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:project)     { FactoryBot.build(:project) }
      let(:task_params) { { 'title' => 'Do Something' } }
      let(:params) do
        super().merge('project_id' => project.id, 'task' => task_params)
      end
      let(:expected_value) do
        next_value.merge('project' => project)
      end
      let(:expected_task_params) do
        task_params.merge('project' => project)
      end
      let(:expected_params) do
        request.params.merge('task' => expected_task_params)
      end
      let(:expected_request) do
        be_a(Cuprum::Rails::Request).and(
          have_attributes(**request.properties, params: expected_params)
        )
      end

      before(:example) do
        insert('projects', project)
      end

      it 'should return a passing result' do
        expect(call_command)
          .to be_a_passing_result
          .with_value(expected_value)
      end

      include_examples 'should call the next command'
    end

    describe 'with task_id: a valid slug' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:project)     { FactoryBot.build(:project) }
      let(:task_params) { { 'title' => 'Do Something' } }
      let(:params) do
        super().merge('project_id' => project.slug, 'task' => task_params)
      end
      let(:expected_value) do
        next_value.merge('project' => project)
      end
      let(:expected_task_params) do
        task_params.merge('project' => project)
      end
      let(:expected_params) do
        request.params.merge('task' => expected_task_params)
      end
      let(:expected_request) do
        be_a(Cuprum::Rails::Request).and(
          have_attributes(**request.properties, params: expected_params)
        )
      end

      before(:example) do
        insert('projects', project)
      end

      it 'should return a passing result' do
        expect(call_command)
          .to be_a_passing_result
          .with_value(expected_value)
      end

      include_examples 'should call the next command'
    end
  end
end
