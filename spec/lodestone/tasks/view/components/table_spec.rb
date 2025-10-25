# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Tasks::View::Components::Table, type: :component do
  include Librum::Components::RSpec::Deferred::ComponentExamples

  subject(:component) do
    described_class.new(**required_keywords, **component_options)
  end

  let(:component_options) do
    {
      data:,
      routes:
    }
  end
  let(:required_keywords) { { resource:, result: } }
  let(:data)              { [] }
  let(:result)            { Cuprum::Result.new }
  let(:resource) do
    Librum::Components::Resource.new(name: 'tasks', title_attribute: 'title')
  end
  let(:routes) do
    Cuprum::Rails::Routing::PluralRoutes.new(base_path: '/tasks')
  end

  describe '#call' do
    let(:data_attributes) do
      data.map do |task|
        <<~TEXT.strip
          data-action="submit->librum-components-confirm-form#submit" data-controller="librum-components-confirm-form" data-librum-components-confirm-form-message-value="#{confirm_message(task.title)}"
        TEXT
      end
    end
    let(:rendered) { pretty_render(component) }
    let(:snapshot) do
      <<~HTML
        <table class="table is-fullwidth">
          <thead>
            <tr>
              <th>
                Task
              </th>

              <th>
                Title
              </th>

              <th>
                Task Type
              </th>

              <th>
                Status
              </th>

              <th>
                &nbsp;
              </th>
            </tr>
          </thead>

          <tbody>
            <tr>
              <td colspan="5">
                There are no tasks matching the criteria.
              </td>
            </tr>
          </tbody>
        </table>
      HTML
    end

    define_method :confirm_message do |title|
      "This will permanently delete task #{title}.\\n\\n" \
        'Confirm deletion?'
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with data' do
      let(:data) do
        [
          FactoryBot.build(
            :task,
            title:     'Investigate Mystery',
            slug:      'investigate-mystery',
            status:    Task::Statuses::TO_DO,
            task_type: Task::TaskTypes::INVESTIGATION
          ),
          FactoryBot.build(
            :task,
            title:     'Confirm Hypothesis',
            slug:      'confirm-hypothesis',
            status:    Task::Statuses::IN_PROGRESS,
            task_type: Task::TaskTypes::FEATURE
          ),
          FactoryBot.build(
            :task,
            title:     'Publish Results',
            slug:      'publish-results',
            status:    Task::Statuses::DONE,
            task_type: Task::TaskTypes::RELEASE
          )
        ]
      end
      let(:snapshot) do
        <<~HTML
          <table class="table is-fullwidth">
            <thead>
              <tr>
                <th>
                  Task
                </th>

                <th>
                  Title
                </th>

                <th>
                  Task Type
                </th>

                <th>
                  Status
                </th>

                <th>
                  &nbsp;
                </th>
              </tr>
            </thead>

            <tbody>
              <tr>
                <td>
                  investigate-mystery
                </td>

                <td>
                  Investigate Mystery
                </td>

                <td>
                  Investigation
                </td>

                <td>
                  To Do
                </td>

                <td>
                  <div class="buttons is-right is-gapless">
                    <a class="button has-text-info is-borderless is-shadowless mx-0 px-1 py-0" href="/tasks/investigate-mystery">
                      Show
                    </a>

                    <a class="button has-text-warning is-borderless is-shadowless mx-0 px-1 py-0" href="/tasks/investigate-mystery/edit">
                      Update
                    </a>

                    <form class="is-inline-block" #{data_attributes[0]} action="/tasks/investigate-mystery" accept-charset="UTF-8" method="post">
                      <input type="hidden" name="_method" value="delete" autocomplete="off">

                      <button class="button has-text-danger is-borderless is-shadowless mx-0 px-1 py-0" type="submit">
                        Destroy
                      </button>
                    </form>
                  </div>
                </td>
              </tr>

              <tr>
                <td>
                  confirm-hypothesis
                </td>

                <td>
                  Confirm Hypothesis
                </td>

                <td>
                  Feature
                </td>

                <td>
                  In Progress
                </td>

                <td>
                  <div class="buttons is-right is-gapless">
                    <a class="button has-text-info is-borderless is-shadowless mx-0 px-1 py-0" href="/tasks/confirm-hypothesis">
                      Show
                    </a>

                    <a class="button has-text-warning is-borderless is-shadowless mx-0 px-1 py-0" href="/tasks/confirm-hypothesis/edit">
                      Update
                    </a>

                    <form class="is-inline-block" #{data_attributes[1]} action="/tasks/confirm-hypothesis" accept-charset="UTF-8" method="post">
                      <input type="hidden" name="_method" value="delete" autocomplete="off">

                      <button class="button has-text-danger is-borderless is-shadowless mx-0 px-1 py-0" type="submit">
                        Destroy
                      </button>
                    </form>
                  </div>
                </td>
              </tr>

              <tr>
                <td>
                  publish-results
                </td>

                <td>
                  Publish Results
                </td>

                <td>
                  Release
                </td>

                <td>
                  Done
                </td>

                <td>
                  <div class="buttons is-right is-gapless">
                    <a class="button has-text-info is-borderless is-shadowless mx-0 px-1 py-0" href="/tasks/publish-results">
                      Show
                    </a>

                    <a class="button has-text-warning is-borderless is-shadowless mx-0 px-1 py-0" href="/tasks/publish-results/edit">
                      Update
                    </a>

                    <form class="is-inline-block" #{data_attributes[2]} action="/tasks/publish-results" accept-charset="UTF-8" method="post">
                      <input type="hidden" name="_method" value="delete" autocomplete="off">

                      <button class="button has-text-danger is-borderless is-shadowless mx-0 px-1 py-0" type="submit">
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
