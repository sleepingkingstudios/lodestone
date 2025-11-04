# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Tasks::View::Show, type: :component do
  subject(:component) { described_class.new(request:, resource:, result:) }

  let(:resource_options) do
    {
      components:      Lodestone::Projects::View::Components,
      title_attribute: 'title'
    }
  end
  let(:request) { Cuprum::Rails::Request.new }
  let(:resource) do
    Librum::Core::Resource.new(name: 'tasks', **resource_options)
  end
  let(:result) { Cuprum::Rails::Result.new }

  describe '#call' do
    let(:rendered) { pretty_render(component) }
    let(:snapshot) do
      <<~HTML
        <h1 class="has-text-overflow-ellipsis">
          Show Task
        </h1>

        <div class="fixed-grid has-0-cols has-4-cols-tablet has-6-cols-desktop">
          <div class="grid">
            <div class="cell has-text-weight-semibold">
              Name
            </div>

            <div class="cell is-col-span-3 is-col-span-5-desktop">
              &nbsp;
            </div>

            <div class="cell has-text-weight-semibold">
              Active
            </div>

            <div class="cell is-col-span-3 is-col-span-5-desktop">
              False
            </div>

            <div class="cell has-text-weight-semibold">
              Public
            </div>

            <div class="cell is-col-span-3 is-col-span-5-desktop">
              False
            </div>

            <div class="cell has-text-weight-semibold">
              Project Type
            </div>

            <div class="cell is-col-span-3 is-col-span-5-desktop">
              &nbsp;
            </div>

            <div class="cell has-text-weight-semibold">
              Repository
            </div>

            <div class="cell is-col-span-3 is-col-span-5-desktop">
              &nbsp;
            </div>
          </div>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with a result with a task' do
      let(:example_application) do
        FactoryBot.build(
          :project,
          name: 'Example Application',
          slug: 'ex-app'
        )
      end
      let(:task) do
        FactoryBot.build(
          :task,
          project:     example_application,
          title:       'Example Task',
          slug:        'ex-app-0',
          description: 'This is an example task.'
        )
      end
      let(:result) do
        Cuprum::Rails::Result.new(
          value: { 'task' => task }
        )
      end
      let(:snapshot) do
        <<~HTML
          <div class="level mb-5">
            <div class="level-left level-shrink is-overflow-hidden">
              <h1 class="mb-0 has-text-overflow-ellipsis">
                Example Task
              </h1>
            </div>

            <div class="level-right">
              <div class="level-item">
                <a class="button" href="/tasks/ex-app-0/edit">
                  <span class="icon">
                    <i class="fa-solid fa-pencil"></i>
                  </span>

                  <span>
                    Update Task
                  </span>
                </a>
              </div>

              <div class="level-item">
                <form class="is-inline-block" data-action="submit->librum-components-confirm-form#submit" data-controller="librum-components-confirm-form" data-librum-components-confirm-form-message-value="This will permanently delete task Example Task.\\n\\nConfirm deletion?" action="/tasks/ex-app-0" accept-charset="UTF-8" method="post">
                  <input type="hidden" name="_method" value="delete" autocomplete="off">

                  <button class="button is-danger is-outlined" type="submit">
                    <span class="icon">
                      <i class="fa-solid fa-eraser"></i>
                    </span>

                    <span>
                      Destroy Task
                    </span>
                  </button>
                </form>
              </div>
            </div>
          </div>

          <p>
            <a class="icon-text has-text-link" href="/projects/ex-app/board">
              <span class="icon">
                <i class="fa-solid fa-rectangle-list"></i>
              </span>

              Project Board
            </a>
          </p>

          <div class="fixed-grid has-0-cols has-4-cols-tablet has-6-cols-desktop">
            <div class="grid">
              <div class="cell has-text-weight-semibold">
                Name
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                &nbsp;
              </div>

              <div class="cell has-text-weight-semibold">
                Active
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                False
              </div>

              <div class="cell has-text-weight-semibold">
                Public
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                False
              </div>

              <div class="cell has-text-weight-semibold">
                Project Type
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                &nbsp;
              </div>

              <div class="cell has-text-weight-semibold">
                Repository
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                &nbsp;
              </div>
            </div>
          </div>

          <p>
            This is an example task.
          </p>

          <div class="level mb-5">
            <div class="level-left level-shrink is-overflow-hidden">
              <h2 class="mb-0 has-text-overflow-ellipsis">
                Relationships
              </h2>
            </div>

            <div class="level-right">
              <div class="level-item">
                <a class="button" href="/tasks/ex-app-0/relationships/new">
                  <span class="icon">
                    <i class="fa-solid fa-plus"></i>
                  </span>

                  <span>
                    Create Relationship
                  </span>
                </a>
              </div>
            </div>
          </div>

          <table class="table is-fullwidth multi-body">
            <thead>
              <tr>
                <th>
                  Type
                </th>

                <th>
                  Project
                </th>

                <th>
                  Task
                </th>

                <th>
                  &nbsp;
                </th>
              </tr>
            </thead>

            <tbody>
              <tr>
                <td colspan="4">
                  The task has no relationships.
                </td>
              </tr>
            </tbody>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a result with a task with relationships' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:example_application) do
        FactoryBot.build(
          :project,
          name: 'Example Application',
          slug: 'ex-app'
        )
      end
      let(:example_library) do
        FactoryBot.build(
          :project,
          name: 'Example Library',
          slug: 'ex-lib'
        )
      end
      let(:task) do
        FactoryBot.build(
          :task,
          project:     example_application,
          title:       'Example Task',
          slug:        'ex-app-0',
          description: 'This is an example task.'
        )
      end
      let(:second_task) do
        FactoryBot.build(
          :task,
          project: example_application,
          title:   'Second Task',
          slug:    'ex-app-1'
        )
      end
      let(:third_task) do
        FactoryBot.build(
          :task,
          project: example_library,
          title:   'Third Task',
          slug:    'ex-lib-0'
        )
      end
      let(:fourth_task) do
        FactoryBot.build(
          :task,
          project: example_library,
          title:   'Fourth Task',
          slug:    'ex-lib-1'
        )
      end
      let(:relationships) do
        [
          FactoryBot.build(
            :task_relationship,
            id:                '00000000-0000-0000-0000-000000000000',
            source_task:       task,
            target_task:       second_task,
            relationship_type: TaskRelationship::RelationshipTypes::DEPENDS_ON
          ),
          FactoryBot.build(
            :task_relationship,
            id:                '00000000-0000-0000-0000-000000000001',
            source_task:       task,
            target_task:       third_task,
            relationship_type: TaskRelationship::RelationshipTypes::RELATES_TO
          )
        ]
      end
      let(:inverse_relationships) do
        [
          FactoryBot.build(
            :task_relationship,
            id:                '00000000-0000-0000-0000-000000000002',
            source_task:       third_task,
            target_task:       task,
            relationship_type: TaskRelationship::RelationshipTypes::RELATES_TO
          ),
          FactoryBot.build(
            :task_relationship,
            id:                '00000000-0000-0000-0000-000000000003',
            source_task:       fourth_task,
            target_task:       task,
            relationship_type: TaskRelationship::RelationshipTypes::DEPENDS_ON
          )
        ]
      end
      let(:result) do
        Cuprum::Rails::Result.new(
          value: {
            'task'                  => task,
            'inverse_relationships' => inverse_relationships,
            'relationships'         => relationships
          }
        )
      end
      let(:snapshot) do
        <<~HTML
          <div class="level mb-5">
            <div class="level-left level-shrink is-overflow-hidden">
              <h1 class="mb-0 has-text-overflow-ellipsis">
                Example Task
              </h1>
            </div>

            <div class="level-right">
              <div class="level-item">
                <a class="button" href="/tasks/ex-app-0/edit">
                  <span class="icon">
                    <i class="fa-solid fa-pencil"></i>
                  </span>

                  <span>
                    Update Task
                  </span>
                </a>
              </div>

              <div class="level-item">
                <form class="is-inline-block" data-action="submit->librum-components-confirm-form#submit" data-controller="librum-components-confirm-form" data-librum-components-confirm-form-message-value="This will permanently delete task Example Task.\\n\\nConfirm deletion?" action="/tasks/ex-app-0" accept-charset="UTF-8" method="post">
                  <input type="hidden" name="_method" value="delete" autocomplete="off">

                  <button class="button is-danger is-outlined" type="submit">
                    <span class="icon">
                      <i class="fa-solid fa-eraser"></i>
                    </span>

                    <span>
                      Destroy Task
                    </span>
                  </button>
                </form>
              </div>
            </div>
          </div>

          <p>
            <a class="icon-text has-text-link" href="/projects/ex-app/board">
              <span class="icon">
                <i class="fa-solid fa-rectangle-list"></i>
              </span>

              Project Board
            </a>
          </p>

          <div class="fixed-grid has-0-cols has-4-cols-tablet has-6-cols-desktop">
            <div class="grid">
              <div class="cell has-text-weight-semibold">
                Name
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                &nbsp;
              </div>

              <div class="cell has-text-weight-semibold">
                Active
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                False
              </div>

              <div class="cell has-text-weight-semibold">
                Public
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                False
              </div>

              <div class="cell has-text-weight-semibold">
                Project Type
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                &nbsp;
              </div>

              <div class="cell has-text-weight-semibold">
                Repository
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                &nbsp;
              </div>
            </div>
          </div>

          <p>
            This is an example task.
          </p>

          <div class="level mb-5">
            <div class="level-left level-shrink is-overflow-hidden">
              <h2 class="mb-0 has-text-overflow-ellipsis">
                Relationships
              </h2>
            </div>

            <div class="level-right">
              <div class="level-item">
                <a class="button" href="/tasks/ex-app-0/relationships/new">
                  <span class="icon">
                    <i class="fa-solid fa-plus"></i>
                  </span>

                  <span>
                    Create Relationship
                  </span>
                </a>
              </div>
            </div>
          </div>

          <table class="table is-fullwidth multi-body">
            <thead>
              <tr>
                <th>
                  Type
                </th>

                <th>
                  Project
                </th>

                <th>
                  Task
                </th>

                <th>
                  &nbsp;
                </th>
              </tr>
            </thead>

            <tbody>
              <tr class="joined-rows">
                <td>
                  Depends On
                </td>

                <td>
                  <a href="/projects/ex-app">
                    Example Application
                  </a>
                </td>

                <td>
                  <a class="has-text-link" href="/tasks/ex-app-1">
                    Second Task
                  </a>
                </td>

                <td>
                  <div class="buttons is-right is-gapless">
                    <a class="button has-text-warning is-borderless is-shadowless m-0 p-0 px-1" href="/tasks/ex-app-0/relationships/00000000-0000-0000-0000-000000000000/edit">
                      Update
                    </a>

                    <form class="is-inline-block" data-action="submit->librum-components-confirm-form#submit" data-controller="librum-components-confirm-form" data-librum-components-confirm-form-message-value="This will permanently delete task_relationship 00000000-0000-0000-0000-000000000000.\\n\\nConfirm deletion?" action="/tasks/ex-app-0/relationships/00000000-0000-0000-0000-000000000000" accept-charset="UTF-8" method="post">
                      <input type="hidden" name="_method" value="delete" autocomplete="off">

                      <button class="button has-text-danger is-borderless is-shadowless m-0 p-0 px-1" type="submit">
                        Destroy
                      </button>
                    </form>
                  </div>
                </td>
              </tr>

              <tr class="joined-rows">
                <td>
                  Relates To
                </td>

                <td>
                  <a href="/projects/ex-lib">
                    Example Library
                  </a>
                </td>

                <td>
                  <a class="has-text-link" href="/tasks/ex-lib-0">
                    Third Task
                  </a>
                </td>

                <td>
                  <div class="buttons is-right is-gapless">
                    <a class="button has-text-warning is-borderless is-shadowless m-0 p-0 px-1" href="/tasks/ex-app-0/relationships/00000000-0000-0000-0000-000000000001/edit">
                      Update
                    </a>

                    <form class="is-inline-block" data-action="submit->librum-components-confirm-form#submit" data-controller="librum-components-confirm-form" data-librum-components-confirm-form-message-value="This will permanently delete task_relationship 00000000-0000-0000-0000-000000000001.\\n\\nConfirm deletion?" action="/tasks/ex-app-0/relationships/00000000-0000-0000-0000-000000000001" accept-charset="UTF-8" method="post">
                      <input type="hidden" name="_method" value="delete" autocomplete="off">

                      <button class="button has-text-danger is-borderless is-shadowless m-0 p-0 px-1" type="submit">
                        Destroy
                      </button>
                    </form>
                  </div>
                </td>
              </tr>
            </tbody>

            <tbody>
              <tr class="joined-rows">
                <td>
                  Related To
                </td>

                <td>
                  <a href="/projects/ex-lib">
                    Example Library
                  </a>
                </td>

                <td>
                  <a class="has-text-link" href="/tasks/ex-lib-0">
                    Third Task
                  </a>
                </td>

                <td>
                  <div class="buttons is-right is-gapless">
                    <a class="button has-text-warning is-borderless is-shadowless m-0 p-0 px-1" href="/tasks/ex-lib-0/relationships/00000000-0000-0000-0000-000000000002/edit">
                      Update
                    </a>

                    <form class="is-inline-block" data-action="submit->librum-components-confirm-form#submit" data-controller="librum-components-confirm-form" data-librum-components-confirm-form-message-value="This will permanently delete task_relationship 00000000-0000-0000-0000-000000000002.\\n\\nConfirm deletion?" action="/tasks/ex-lib-0/relationships/00000000-0000-0000-0000-000000000002" accept-charset="UTF-8" method="post">
                      <input type="hidden" name="_method" value="delete" autocomplete="off">

                      <button class="button has-text-danger is-borderless is-shadowless m-0 p-0 px-1" type="submit">
                        Destroy
                      </button>
                    </form>
                  </div>
                </td>
              </tr>

              <tr class="joined-rows">
                <td>
                  Dependency Of
                </td>

                <td>
                  <a href="/projects/ex-lib">
                    Example Library
                  </a>
                </td>

                <td>
                  <a class="has-text-link" href="/tasks/ex-lib-1">
                    Fourth Task
                  </a>
                </td>

                <td>
                  <div class="buttons is-right is-gapless">
                    <a class="button has-text-warning is-borderless is-shadowless m-0 p-0 px-1" href="/tasks/ex-lib-1/relationships/00000000-0000-0000-0000-000000000003/edit">
                      Update
                    </a>

                    <form class="is-inline-block" data-action="submit->librum-components-confirm-form#submit" data-controller="librum-components-confirm-form" data-librum-components-confirm-form-message-value="This will permanently delete task_relationship 00000000-0000-0000-0000-000000000003.\\n\\nConfirm deletion?" action="/tasks/ex-lib-1/relationships/00000000-0000-0000-0000-000000000003" accept-charset="UTF-8" method="post">
                      <input type="hidden" name="_method" value="delete" autocomplete="off">

                      <button class="button has-text-danger is-borderless is-shadowless m-0 p-0 px-1" type="submit">
                        Destroy
                      </button>
                    </form>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
