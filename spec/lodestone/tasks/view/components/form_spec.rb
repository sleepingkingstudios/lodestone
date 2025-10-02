# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Tasks::View::Components::Form, type: :component do
  subject(:component) { described_class.new(**component_options) }

  let(:component_options) do
    {
      resource:,
      result:,
      routes:
    }
  end
  let(:action_name) { :create }
  let(:result) do
    Cuprum::Rails::Result.new(metadata: { 'action_name' => action_name })
  end
  let(:resource) do
    Cuprum::Rails::Resource.new(name: 'tasks')
  end
  let(:routes) do
    Cuprum::Rails::Routing::PluralRoutes.new(base_path: '/tasks')
  end

  describe '#call' do
    let(:rendered) { pretty_render(component) }

    describe 'with action_name: :create' do
      let(:action_name) { :create }
      let(:snapshot) do
        <<~HTML
          <form class="fixed-grid has-3-cols" action="/tasks" accept-charset="UTF-8" method="post">
            <div class="grid">
              <div class="field cell is-col-span-3">
                <label class="label">
                  Title
                </label>

                <div class="control">
                  <input name="task[title]" class="input" type="text">
                </div>
              </div>

              <div class="field">
                <label class="label">
                  Project
                </label>

                <div class="control">
                  <div class="select is-block">
                    <select name="task[project_id]">
                      <option value=""></option>

                      <option>
                        No Projects Found
                      </option>
                    </select>
                  </div>
                </div>
              </div>

              <div class="field">
                <label class="label">
                  Task Type
                </label>

                <div class="control">
                  <div class="select is-block">
                    <select name="task[task_type]">
                      <option value="bugfix">
                        Bugfix
                      </option>

                      <option value="chore">
                        Chore
                      </option>

                      <option value="epic">
                        Epic
                      </option>

                      <option value="feature">
                        Feature
                      </option>

                      <option value="investigation">
                        Investigation
                      </option>

                      <option value="milestone">
                        Milestone
                      </option>

                      <option value="release">
                        Release
                      </option>
                    </select>
                  </div>
                </div>
              </div>

              <div class="field">
                <label class="label">
                  Status
                </label>

                <div class="control">
                  <div class="select is-block">
                    <select name="task[status]">
                      <option value="wont_do">
                        Won't Do
                      </option>

                      <option value="icebox">
                        Icebox
                      </option>

                      <option value="to_do">
                        To Do
                      </option>

                      <option value="in_progress">
                        In Progress
                      </option>

                      <option value="done">
                        Done
                      </option>

                      <option value="archived">
                        Archived
                      </option>
                    </select>
                  </div>
                </div>
              </div>

              <div class="field cell is-col-span-3">
                <label class="label">
                  Description
                </label>

                <div class="control">
                  <textarea name="task[description]" class="textarea"></textarea>
                </div>
              </div>

              <div class="field is-grouped cell is-col-span-3">
                <p class="control">
                  <button class="button is-link" type="submit">
                    <span class="icon">
                      <i class="fa-solid fa-plus"></i>
                    </span>

                    <span>
                      Create Task
                    </span>
                  </button>
                </p>

                <p class="control">
                  <a class="button" href="/tasks">
                    Cancel
                  </a>
                </p>
              </div>
            </div>
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with a result with data' do
        let(:projects) do
          [
            FactoryBot.build(
              :project,
              id:   '00000000-0000-0000-0000-000000000000',
              name: 'Example Application',
              slug: 'ex-app'
            ),
            FactoryBot.build(
              :project,
              id:   '00000000-0000-0000-0000-000000000001',
              name: 'Example Library',
              slug: 'ex-lib'
            )
          ]
        end
        let(:task) do
          FactoryBot.build(
            :task,
            project:     projects.first,
            title:       'Example Task',
            slug:        'ex-app-0',
            task_type:   Task::TaskTypes::INVESTIGATION,
            status:      Task::Statuses::IN_PROGRESS,
            description: 'This is an example task.'
          )
        end
        let(:result) do
          Cuprum::Rails::Result.new(
            **super().properties,
            value: { 'projects' => projects, 'task' => task }
          )
        end
        let(:snapshot) do
          <<~HTML
            <form class="fixed-grid has-3-cols" action="/tasks" accept-charset="UTF-8" method="post">
              <div class="grid">
                <div class="field cell is-col-span-3">
                  <label class="label">
                    Title
                  </label>

                  <div class="control">
                    <input name="task[title]" class="input" type="text" value="Example Task">
                  </div>
                </div>

                <div class="field">
                  <label class="label">
                    Project
                  </label>

                  <div class="control">
                    <div class="select is-block">
                      <select name="task[project_id]">
                        <option value=""></option>

                        <option value="00000000-0000-0000-0000-000000000000" selected="selected">
                          Example Application
                        </option>

                        <option value="00000000-0000-0000-0000-000000000001">
                          Example Library
                        </option>
                      </select>
                    </div>
                  </div>
                </div>

                <div class="field">
                  <label class="label">
                    Task Type
                  </label>

                  <div class="control">
                    <div class="select is-block">
                      <select name="task[task_type]">
                        <option value="bugfix">
                          Bugfix
                        </option>

                        <option value="chore">
                          Chore
                        </option>

                        <option value="epic">
                          Epic
                        </option>

                        <option value="feature">
                          Feature
                        </option>

                        <option value="investigation" selected="selected">
                          Investigation
                        </option>

                        <option value="milestone">
                          Milestone
                        </option>

                        <option value="release">
                          Release
                        </option>
                      </select>
                    </div>
                  </div>
                </div>

                <div class="field">
                  <label class="label">
                    Status
                  </label>

                  <div class="control">
                    <div class="select is-block">
                      <select name="task[status]">
                        <option value="wont_do">
                          Won't Do
                        </option>

                        <option value="icebox">
                          Icebox
                        </option>

                        <option value="to_do">
                          To Do
                        </option>

                        <option value="in_progress" selected="selected">
                          In Progress
                        </option>

                        <option value="done">
                          Done
                        </option>

                        <option value="archived">
                          Archived
                        </option>
                      </select>
                    </div>
                  </div>
                </div>

                <div class="field cell is-col-span-3">
                  <label class="label">
                    Description
                  </label>

                  <div class="control">
                    <textarea name="task[description]" class="textarea">
                      This is an example task.
                    </textarea>
                  </div>
                </div>

                <div class="field is-grouped cell is-col-span-3">
                  <p class="control">
                    <button class="button is-link" type="submit">
                      <span class="icon">
                        <i class="fa-solid fa-plus"></i>
                      </span>

                      <span>
                        Create Task
                      </span>
                    </button>
                  </p>

                  <p class="control">
                    <a class="button" href="/tasks">
                      Cancel
                    </a>
                  </p>
                </div>
              </div>
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with a result with data and errors' do
        let(:projects) do
          [
            FactoryBot.build(
              :project,
              id:   '00000000-0000-0000-0000-000000000000',
              name: 'Example Application',
              slug: 'ex-app'
            ),
            FactoryBot.build(
              :project,
              id:   '00000000-0000-0000-0000-000000000001',
              name: 'Example Library',
              slug: 'ex-lib'
            )
          ]
        end
        let(:task) do
          FactoryBot.build(
            :task,
            project:     projects.first,
            title:       'Example Task',
            slug:        'ex-app-0',
            task_type:   Task::TaskTypes::INVESTIGATION,
            status:      Task::Statuses::IN_PROGRESS,
            description: 'This is an example task.'
          )
        end
        let(:errors) do
          Stannum::Errors.new.tap do |err|
            err['task']['title'].add('taken', message: 'is taken')
            err['task']['project_id'].add('offline', message: 'is offline')
          end
        end
        let(:result) do
          Cuprum::Rails::Result.new(
            **super().properties,
            value: { 'projects' => projects, 'task' => task },
            error: Struct.new(:errors).new(errors)
          )
        end
        let(:snapshot) do
          <<~HTML
            <form class="fixed-grid has-3-cols" action="/tasks" accept-charset="UTF-8" method="post">
              <div class="grid">
                <div class="field cell is-col-span-3">
                  <label class="label">
                    Title
                  </label>

                  <div class="control has-icons-right">
                    <input name="task[title]" class="input is-danger" type="text" value="Example Task">

                    <span class="icon is-small is-right">
                      <i class="fa-solid fa-exclamation-triangle"></i>
                    </span>
                  </div>

                  <p class="help is-danger">
                    is taken
                  </p>
                </div>

                <div class="field">
                  <label class="label">
                    Project
                  </label>

                  <div class="control">
                    <div class="select is-danger is-block">
                      <select name="task[project_id]">
                        <option value=""></option>

                        <option value="00000000-0000-0000-0000-000000000000" selected="selected">
                          Example Application
                        </option>

                        <option value="00000000-0000-0000-0000-000000000001">
                          Example Library
                        </option>
                      </select>
                    </div>
                  </div>

                  <p class="help is-danger">
                    is offline
                  </p>
                </div>

                <div class="field">
                  <label class="label">
                    Task Type
                  </label>

                  <div class="control">
                    <div class="select is-block">
                      <select name="task[task_type]">
                        <option value="bugfix">
                          Bugfix
                        </option>

                        <option value="chore">
                          Chore
                        </option>

                        <option value="epic">
                          Epic
                        </option>

                        <option value="feature">
                          Feature
                        </option>

                        <option value="investigation" selected="selected">
                          Investigation
                        </option>

                        <option value="milestone">
                          Milestone
                        </option>

                        <option value="release">
                          Release
                        </option>
                      </select>
                    </div>
                  </div>
                </div>

                <div class="field">
                  <label class="label">
                    Status
                  </label>

                  <div class="control">
                    <div class="select is-block">
                      <select name="task[status]">
                        <option value="wont_do">
                          Won't Do
                        </option>

                        <option value="icebox">
                          Icebox
                        </option>

                        <option value="to_do">
                          To Do
                        </option>

                        <option value="in_progress" selected="selected">
                          In Progress
                        </option>

                        <option value="done">
                          Done
                        </option>

                        <option value="archived">
                          Archived
                        </option>
                      </select>
                    </div>
                  </div>
                </div>

                <div class="field cell is-col-span-3">
                  <label class="label">
                    Description
                  </label>

                  <div class="control">
                    <textarea name="task[description]" class="textarea">
                      This is an example task.
                    </textarea>
                  </div>
                </div>

                <div class="field is-grouped cell is-col-span-3">
                  <p class="control">
                    <button class="button is-link" type="submit">
                      <span class="icon">
                        <i class="fa-solid fa-plus"></i>
                      </span>

                      <span>
                        Create Task
                      </span>
                    </button>
                  </p>

                  <p class="control">
                    <a class="button" href="/tasks">
                      Cancel
                    </a>
                  </p>
                </div>
              </div>
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with action_name: :update' do
      let(:action_name) { :update }
      let(:routes) do
        super().with_wildcards({ id: 'ex-app-0' })
      end
      let(:snapshot) do
        <<~HTML
          <form class="fixed-grid has-3-cols" action="/tasks/ex-app-0" accept-charset="UTF-8" method="post">
            <input type="hidden" name="_method" value="patch" autocomplete="off">

            <div class="grid">
              <div class="field cell is-col-span-3">
                <label class="label">
                  Title
                </label>

                <div class="control">
                  <input name="task[title]" class="input" type="text">
                </div>
              </div>

              <div class="field">
                <label class="label">
                  Project
                </label>

                <div class="control">
                  <div class="select is-block">
                    <select name="task[project_id]">
                      <option value=""></option>

                      <option>
                        No Projects Found
                      </option>
                    </select>
                  </div>
                </div>
              </div>

              <div class="field">
                <label class="label">
                  Task Type
                </label>

                <div class="control">
                  <div class="select is-block">
                    <select name="task[task_type]">
                      <option value="bugfix">
                        Bugfix
                      </option>

                      <option value="chore">
                        Chore
                      </option>

                      <option value="epic">
                        Epic
                      </option>

                      <option value="feature">
                        Feature
                      </option>

                      <option value="investigation">
                        Investigation
                      </option>

                      <option value="milestone">
                        Milestone
                      </option>

                      <option value="release">
                        Release
                      </option>
                    </select>
                  </div>
                </div>
              </div>

              <div class="field">
                <label class="label">
                  Status
                </label>

                <div class="control">
                  <div class="select is-block">
                    <select name="task[status]">
                      <option value="wont_do">
                        Won't Do
                      </option>

                      <option value="icebox">
                        Icebox
                      </option>

                      <option value="to_do">
                        To Do
                      </option>

                      <option value="in_progress">
                        In Progress
                      </option>

                      <option value="done">
                        Done
                      </option>

                      <option value="archived">
                        Archived
                      </option>
                    </select>
                  </div>
                </div>
              </div>

              <div class="field cell is-col-span-3">
                <label class="label">
                  Description
                </label>

                <div class="control">
                  <textarea name="task[description]" class="textarea"></textarea>
                </div>
              </div>

              <div class="field is-grouped cell is-col-span-3">
                <p class="control">
                  <button class="button is-link" type="submit">
                    <span class="icon">
                      <i class="fa-solid fa-plus"></i>
                    </span>

                    <span>
                      Update Task
                    </span>
                  </button>
                </p>

                <p class="control">
                  <a class="button" href="/tasks/ex-app-0">
                    Cancel
                  </a>
                </p>
              </div>
            </div>
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with a result with data' do
        let(:projects) do
          [
            FactoryBot.build(
              :project,
              id:   '00000000-0000-0000-0000-000000000000',
              name: 'Example Application',
              slug: 'ex-app'
            ),
            FactoryBot.build(
              :project,
              id:   '00000000-0000-0000-0000-000000000001',
              name: 'Example Library',
              slug: 'ex-lib'
            )
          ]
        end
        let(:task) do
          FactoryBot.build(
            :task,
            project:     projects.first,
            title:       'Example Task',
            slug:        'ex-app-0',
            task_type:   Task::TaskTypes::INVESTIGATION,
            status:      Task::Statuses::IN_PROGRESS,
            description: 'This is an example task.'
          )
        end
        let(:result) do
          Cuprum::Rails::Result.new(
            **super().properties,
            value: { 'projects' => projects, 'task' => task }
          )
        end
        let(:snapshot) do
          <<~HTML
            <form class="fixed-grid has-3-cols" action="/tasks/ex-app-0" accept-charset="UTF-8" method="post">
              <input type="hidden" name="_method" value="patch" autocomplete="off">

              <div class="grid">
                <div class="field cell is-col-span-3">
                  <label class="label">
                    Title
                  </label>

                  <div class="control">
                    <input name="task[title]" class="input" type="text" value="Example Task">
                  </div>
                </div>

                <div class="field">
                  <label class="label">
                    Project
                  </label>

                  <div class="control">
                    <div class="select is-block">
                      <select name="task[project_id]">
                        <option value=""></option>

                        <option value="00000000-0000-0000-0000-000000000000" selected="selected">
                          Example Application
                        </option>

                        <option value="00000000-0000-0000-0000-000000000001">
                          Example Library
                        </option>
                      </select>
                    </div>
                  </div>
                </div>

                <div class="field">
                  <label class="label">
                    Task Type
                  </label>

                  <div class="control">
                    <div class="select is-block">
                      <select name="task[task_type]">
                        <option value="bugfix">
                          Bugfix
                        </option>

                        <option value="chore">
                          Chore
                        </option>

                        <option value="epic">
                          Epic
                        </option>

                        <option value="feature">
                          Feature
                        </option>

                        <option value="investigation" selected="selected">
                          Investigation
                        </option>

                        <option value="milestone">
                          Milestone
                        </option>

                        <option value="release">
                          Release
                        </option>
                      </select>
                    </div>
                  </div>
                </div>

                <div class="field">
                  <label class="label">
                    Status
                  </label>

                  <div class="control">
                    <div class="select is-block">
                      <select name="task[status]">
                        <option value="wont_do">
                          Won't Do
                        </option>

                        <option value="icebox">
                          Icebox
                        </option>

                        <option value="to_do">
                          To Do
                        </option>

                        <option value="in_progress" selected="selected">
                          In Progress
                        </option>

                        <option value="done">
                          Done
                        </option>

                        <option value="archived">
                          Archived
                        </option>
                      </select>
                    </div>
                  </div>
                </div>

                <div class="field cell is-col-span-3">
                  <label class="label">
                    Description
                  </label>

                  <div class="control">
                    <textarea name="task[description]" class="textarea">
                      This is an example task.
                    </textarea>
                  </div>
                </div>

                <div class="field is-grouped cell is-col-span-3">
                  <p class="control">
                    <button class="button is-link" type="submit">
                      <span class="icon">
                        <i class="fa-solid fa-plus"></i>
                      </span>

                      <span>
                        Update Task
                      </span>
                    </button>
                  </p>

                  <p class="control">
                    <a class="button" href="/tasks/ex-app-0">
                      Cancel
                    </a>
                  </p>
                </div>
              </div>
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with a result with data and errors' do
        let(:projects) do
          [
            FactoryBot.build(
              :project,
              id:   '00000000-0000-0000-0000-000000000000',
              name: 'Example Application',
              slug: 'ex-app'
            ),
            FactoryBot.build(
              :project,
              id:   '00000000-0000-0000-0000-000000000001',
              name: 'Example Library',
              slug: 'ex-lib'
            )
          ]
        end
        let(:task) do
          FactoryBot.build(
            :task,
            project:     projects.first,
            title:       'Example Task',
            slug:        'ex-app-0',
            task_type:   Task::TaskTypes::INVESTIGATION,
            status:      Task::Statuses::IN_PROGRESS,
            description: 'This is an example task.'
          )
        end
        let(:errors) do
          Stannum::Errors.new.tap do |err|
            err['task']['title'].add('taken', message: 'is taken')
            err['task']['project_id'].add('offline', message: 'is offline')
          end
        end
        let(:result) do
          Cuprum::Rails::Result.new(
            **super().properties,
            value: { 'projects' => projects, 'task' => task },
            error: Struct.new(:errors).new(errors)
          )
        end
        let(:snapshot) do
          <<~HTML
            <form class="fixed-grid has-3-cols" action="/tasks/ex-app-0" accept-charset="UTF-8" method="post">
              <input type="hidden" name="_method" value="patch" autocomplete="off">

              <div class="grid">
                <div class="field cell is-col-span-3">
                  <label class="label">
                    Title
                  </label>

                  <div class="control has-icons-right">
                    <input name="task[title]" class="input is-danger" type="text" value="Example Task">

                    <span class="icon is-small is-right">
                      <i class="fa-solid fa-exclamation-triangle"></i>
                    </span>
                  </div>

                  <p class="help is-danger">
                    is taken
                  </p>
                </div>

                <div class="field">
                  <label class="label">
                    Project
                  </label>

                  <div class="control">
                    <div class="select is-danger is-block">
                      <select name="task[project_id]">
                        <option value=""></option>

                        <option value="00000000-0000-0000-0000-000000000000" selected="selected">
                          Example Application
                        </option>

                        <option value="00000000-0000-0000-0000-000000000001">
                          Example Library
                        </option>
                      </select>
                    </div>
                  </div>

                  <p class="help is-danger">
                    is offline
                  </p>
                </div>

                <div class="field">
                  <label class="label">
                    Task Type
                  </label>

                  <div class="control">
                    <div class="select is-block">
                      <select name="task[task_type]">
                        <option value="bugfix">
                          Bugfix
                        </option>

                        <option value="chore">
                          Chore
                        </option>

                        <option value="epic">
                          Epic
                        </option>

                        <option value="feature">
                          Feature
                        </option>

                        <option value="investigation" selected="selected">
                          Investigation
                        </option>

                        <option value="milestone">
                          Milestone
                        </option>

                        <option value="release">
                          Release
                        </option>
                      </select>
                    </div>
                  </div>
                </div>

                <div class="field">
                  <label class="label">
                    Status
                  </label>

                  <div class="control">
                    <div class="select is-block">
                      <select name="task[status]">
                        <option value="wont_do">
                          Won't Do
                        </option>

                        <option value="icebox">
                          Icebox
                        </option>

                        <option value="to_do">
                          To Do
                        </option>

                        <option value="in_progress" selected="selected">
                          In Progress
                        </option>

                        <option value="done">
                          Done
                        </option>

                        <option value="archived">
                          Archived
                        </option>
                      </select>
                    </div>
                  </div>
                </div>

                <div class="field cell is-col-span-3">
                  <label class="label">
                    Description
                  </label>

                  <div class="control">
                    <textarea name="task[description]" class="textarea">
                      This is an example task.
                    </textarea>
                  </div>
                </div>

                <div class="field is-grouped cell is-col-span-3">
                  <p class="control">
                    <button class="button is-link" type="submit">
                      <span class="icon">
                        <i class="fa-solid fa-plus"></i>
                      </span>

                      <span>
                        Update Task
                      </span>
                    </button>
                  </p>

                  <p class="control">
                    <a class="button" href="/tasks/ex-app-0">
                      Cancel
                    </a>
                  </p>
                </div>
              </div>
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end
end
