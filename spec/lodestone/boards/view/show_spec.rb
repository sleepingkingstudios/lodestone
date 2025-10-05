# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Boards::View::Show, type: :component do
  include Librum::Components::RSpec::Deferred::ComponentExamples

  subject(:component) { described_class.new(result:) }

  let(:result) { Cuprum::Result.new }

  describe '#call' do
    let(:rendered) { pretty_render(component) }
    let(:value)    { {} }
    let(:heading_text) do
      'All Tasks'
    end
    let(:create_path) do
      '/tasks/new'
    end
    let(:empty_message) do
      'There are no matching tasks.'
    end
    let(:columns_snapshot) do
      <<~HTML
        <div class="columns">
          <div class="column">
            <h2 class="has-text-overflow-ellipsis is-size-4">
              Icebox
            </h2>
          </div>

          <div class="column">
            <h2 class="has-text-overflow-ellipsis is-size-4">
              To Do
            </h2>
          </div>

          <div class="column">
            <h2 class="has-text-overflow-ellipsis is-size-4">
              In Progress
            </h2>
          </div>

          <div class="column">
            <h2 class="has-text-overflow-ellipsis is-size-4">
              Done
            </h2>
          </div>
        </div>

        <p class="mt-5">
          #{empty_message}
        </p>

        <p>
          <a class="has-text-success" href="#{create_path}">
            Create Task
          </a>
        </p>
      HTML
    end
    let(:snapshot) do
      <<~HTML
        <div class="level mb-5">
          <div class="level-left level-shrink is-overflow-hidden">
            <h1 class="mb-0 has-text-overflow-ellipsis">
              #{heading_text}
            </h1>
          </div>

          <div class="level-right">
            <div class="level-item">
              <a class="button" href="#{create_path}">
                Create Task
              </a>
            </div>
          </div>
        </div>

        #{columns_snapshot.strip}
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with project: value' do
      let(:result) { Cuprum::Result.new(value:) }
      let(:value)  { super().merge('project' => project) }
      let(:project) do
        FactoryBot.build(
          :project,
          name: 'Example Project',
          slug: 'example-project'
        )
      end
      let(:heading_text) do
        project.name
      end
      let(:create_path) do
        '/projects/example-project/tasks/new'
      end
      let(:empty_message) do
        'There are no matching tasks for project Example Project.'
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with tasks: value' do
      let(:result) { Cuprum::Result.new(value:) }
      let(:value)  { super().merge('tasks' => tasks) }
      let(:tasks) do
        [
          {
            title:  'Example Task',
            slug:   'task-0',
            status: Task::Statuses::ICEBOX
          },
          {
            title:  'Another Task',
            slug:   'task-1',
            status: Task::Statuses::TO_DO
          },
          {
            title:  'Third Task',
            slug:   'task-2',
            status: Task::Statuses::TO_DO
          }
        ]
          .map { |attributes| FactoryBot.build(:task, **attributes) }
          .group_by(&:status)
      end
      let(:columns_snapshot) do
        <<~HTML
          <div class="columns">
            <div class="column">
              <h2 class="has-text-overflow-ellipsis is-size-4">
                Icebox
              </h2>

              <div class="box">
                <p class="has-text-overflow-ellipsis">
                  <a class="has-text-info" href="/tasks/task-0">
                    Example Task
                  </a>
                </p>

                <p class="mb-0">
                  <span class="icon-text">
                    <span class="icon">
                      <i class="fa-solid fa-wrench"></i>
                    </span>

                    <span>
                      Chore
                    </span>
                  </span>
                </p>

                <p>
                  task-0
                </p>
              </div>
            </div>

            <div class="column">
              <h2 class="has-text-overflow-ellipsis is-size-4">
                To Do
              </h2>

              <div class="box">
                <p class="has-text-overflow-ellipsis">
                  <a class="has-text-link" href="/tasks/task-1">
                    Another Task
                  </a>
                </p>

                <p class="mb-0">
                  <span class="icon-text">
                    <span class="icon">
                      <i class="fa-solid fa-wrench"></i>
                    </span>

                    <span>
                      Chore
                    </span>
                  </span>
                </p>

                <p>
                  task-1
                </p>
              </div>

              <div class="box">
                <p class="has-text-overflow-ellipsis">
                  <a class="has-text-link" href="/tasks/task-2">
                    Third Task
                  </a>
                </p>

                <p class="mb-0">
                  <span class="icon-text">
                    <span class="icon">
                      <i class="fa-solid fa-wrench"></i>
                    </span>

                    <span>
                      Chore
                    </span>
                  </span>
                </p>

                <p>
                  task-2
                </p>
              </div>
            </div>

            <div class="column">
              <h2 class="has-text-overflow-ellipsis is-size-4">
                In Progress
              </h2>
            </div>

            <div class="column">
              <h2 class="has-text-overflow-ellipsis is-size-4">
                Done
              </h2>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with project: value' do
        let(:value)  { super().merge('project' => project) }
        let(:project) do
          FactoryBot.build(
            :project,
            name: 'Example Project',
            slug: 'example-project'
          )
        end
        let(:heading_text) do
          project.name
        end
        let(:create_path) do
          '/projects/example-project/tasks/new'
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end
end
