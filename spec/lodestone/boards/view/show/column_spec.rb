# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Boards::View::Show::Column, type: :component do
  include Librum::Components::RSpec::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:component_options) { { status: } }
  let(:status)            { Task::Statuses::TO_DO }

  include_deferred 'should define component option', :status

  include_deferred 'should define component option', :tasks

  describe '#call' do
    let(:rendered) { pretty_render(component) }
    let(:snapshot) do
      <<~HTML
        <h2 class="is-size-4">
          To Do
        </h2>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    context 'with tasks' do
      let(:tasks) do
        [
          {
            title: 'Example Task',
            slug:  'task-0'
          },
          {
            title: 'Another Task',
            slug:  'task-1'
          },
          {
            title: 'Third Task',
            slug:  'task-2'
          }
        ]
          .map { |attributes| FactoryBot.build(:task, **attributes) }
      end
      let(:component_options) { super().merge(tasks:) }
      let(:snapshot) do
        <<~HTML
          <h2 class="is-size-4">
            To Do
          </h2>

          <div class="box">
            <p>
              <a class="has-text-link" href="/tasks/task-0">
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

          <div class="box">
            <p>
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
            <p>
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
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
