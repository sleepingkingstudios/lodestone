# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Boards::View::Components::Task, type: :component do
  include Librum::Components::RSpec::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:task_options) do
    {
      title:     'Example Task',
      slug:      'app-1',
      status:    Task::Statuses::TO_DO,
      task_type: Task::TaskTypes::INVESTIGATION
    }
  end
  let(:task)                { FactoryBot.build(:task, **task_options) }
  let(:component_options)   { { task: } }
  let(:configuration_class) { Librum::Components::Bulma::Configuration }

  describe '.new' do
    include_deferred 'should validate the presence of option', :task

    include_deferred 'should validate the type of option',
      :task,
      expected: ::Task, # rubocop:disable Style/RedundantConstantBase
      required: true
  end

  describe '#call' do
    let(:rendered) { pretty_render(component) }
    let(:snapshot) do
      <<~HTML
        <div class="box">
          <p>
            <a class="has-text-#{link_color}" href="/tasks/app-1">
              Example Task
            </a>
          </p>

          <p class="mb-0">
            <span class="icon-text">
              <span class="icon">
                <i class="fa-solid fa-#{icon}"></i>
              </span>

              #{task.task_type.titleize}
            </span>
          </p>

          <p>
            app-1
          </p>
        </div>
      HTML
    end

    describe 'with a task with status: DONE' do
      let(:task_options) do
        super().merge(status: Task::Statuses::DONE)
      end
      let(:link_color) { 'slate' }
      let(:icon)       { 'search' }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a task with status: ICEBOX' do
      let(:task_options) do
        super().merge(status: Task::Statuses::ICEBOX)
      end
      let(:link_color) { 'info' }
      let(:icon)       { 'search' }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a task with status: IN_PROGRESS' do
      let(:task_options) do
        super().merge(status: Task::Statuses::IN_PROGRESS)
      end
      let(:link_color) { 'success' }
      let(:icon)       { 'search' }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a task with status: TO_DO' do
      let(:task_options) do
        super().merge(status: Task::Statuses::TO_DO)
      end
      let(:link_color) { 'link' }
      let(:icon)       { 'search' }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a task with type: BUGFIX' do
      let(:task_options) do
        super().merge(task_type: Task::TaskTypes::BUGFIX)
      end
      let(:link_color) { 'link' }
      let(:icon)       { 'bug' }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a task with type: CHORE' do
      let(:task_options) do
        super().merge(task_type: Task::TaskTypes::CHORE)
      end
      let(:link_color) { 'link' }
      let(:icon)       { 'wrench' }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a task with type: EPIC' do
      let(:task_options) do
        super().merge(task_type: Task::TaskTypes::EPIC)
      end
      let(:link_color) { 'link' }
      let(:icon)       { 'lightbulb' }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a task with type: FEATURE' do
      let(:task_options) do
        super().merge(task_type: Task::TaskTypes::FEATURE)
      end
      let(:link_color) { 'link' }
      let(:icon)       { 'gear' }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a task with type: INVESTIGATION' do
      let(:task_options) do
        super().merge(task_type: Task::TaskTypes::INVESTIGATION)
      end
      let(:link_color) { 'link' }
      let(:icon)       { 'search' }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a task with type: MILESTONE' do
      let(:task_options) do
        super().merge(task_type: Task::TaskTypes::MILESTONE)
      end
      let(:link_color) { 'link' }
      let(:icon)       { 'trophy' }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a task with type: RELEASE' do
      let(:task_options) do
        super().merge(task_type: Task::TaskTypes::RELEASE)
      end
      let(:link_color) { 'link' }
      let(:icon)       { 'award' }

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
