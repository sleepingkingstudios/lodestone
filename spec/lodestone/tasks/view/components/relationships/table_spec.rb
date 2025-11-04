# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Tasks::View::Components::Relationships::Table,
  type: :component \
do
  subject(:component) do
    described_class.new(**required_keywords, **component_options)
  end

  let(:required_keywords) do
    {
      resource:,
      routes:
    }
  end
  let(:component_options) do
    {
      inverse_relationships:,
      relationships:,
      task:
    }
  end
  let(:resource) do
    Cuprum::Rails::Resource.new(
      actions: %i[create destroy edit new update],
      name:    'task_relationships'
    )
  end
  let(:routes) do
    Cuprum::Rails::Routing::PluralRoutes.new(base_path: '/task_relationships')
  end
  let(:inverse_relationships) { [] }
  let(:relationships)         { [] }
  let(:task)                  { nil }

  describe '#call' do
    # Wrap contents in a table to ensure HTML fragment is valid.
    let(:rendered) { render_component(component) }
    let(:snapshot) do
      <<~HTML
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

    describe 'with a task' do
      let(:task) { FactoryBot.build(:task, title: 'Example Task') }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a task with relationships and inverse relationships' do # rubocop:disable RSpec/MultipleMemoizedHelpers
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
          project: example_application,
          title:   'Example Task',
          slug:    'ex-app-0'
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
      let(:snapshot) do
        <<~HTML
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
                    <a class="button has-text-warning is-borderless is-shadowless m-0 p-0 px-1" href="/task_relationships/00000000-0000-0000-0000-000000000000/edit">
                      Update
                    </a>

                    <form class="is-inline-block" data-action="submit->librum-components-confirm-form#submit" data-controller="librum-components-confirm-form" data-librum-components-confirm-form-message-value="This will permanently delete task_relationship 00000000-0000-0000-0000-000000000000.\\n\\nConfirm deletion?" action="/task_relationships/00000000-0000-0000-0000-000000000000" accept-charset="UTF-8" method="post">
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
                    <a class="button has-text-warning is-borderless is-shadowless m-0 p-0 px-1" href="/task_relationships/00000000-0000-0000-0000-000000000001/edit">
                      Update
                    </a>

                    <form class="is-inline-block" data-action="submit->librum-components-confirm-form#submit" data-controller="librum-components-confirm-form" data-librum-components-confirm-form-message-value="This will permanently delete task_relationship 00000000-0000-0000-0000-000000000001.\\n\\nConfirm deletion?" action="/task_relationships/00000000-0000-0000-0000-000000000001" accept-charset="UTF-8" method="post">
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
                    <a class="button has-text-warning is-borderless is-shadowless m-0 p-0 px-1" href="/task_relationships/00000000-0000-0000-0000-000000000002/edit">
                      Update
                    </a>

                    <form class="is-inline-block" data-action="submit->librum-components-confirm-form#submit" data-controller="librum-components-confirm-form" data-librum-components-confirm-form-message-value="This will permanently delete task_relationship 00000000-0000-0000-0000-000000000002.\\n\\nConfirm deletion?" action="/task_relationships/00000000-0000-0000-0000-000000000002" accept-charset="UTF-8" method="post">
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
                    <a class="button has-text-warning is-borderless is-shadowless m-0 p-0 px-1" href="/task_relationships/00000000-0000-0000-0000-000000000003/edit">
                      Update
                    </a>

                    <form class="is-inline-block" data-action="submit->librum-components-confirm-form#submit" data-controller="librum-components-confirm-form" data-librum-components-confirm-form-message-value="This will permanently delete task_relationship 00000000-0000-0000-0000-000000000003.\\n\\nConfirm deletion?" action="/task_relationships/00000000-0000-0000-0000-000000000003" accept-charset="UTF-8" method="post">
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
