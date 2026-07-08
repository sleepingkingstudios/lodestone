# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Tasks::View::Components::Links, type: :component do
  subject(:component) { described_class.new(**component_options) }

  let(:task_attributes) { { slug: 'example-task' } }
  let(:project) do
    FactoryBot.build(:project, slug: 'example-project')
  end
  let(:task) do
    FactoryBot.build(:task, project:, **task_attributes)
  end
  let(:component_options) { { task: } }

  include_deferred 'should define component option', :task

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <div class="fixed-grid has-1-cols has-4-cols-tablet has-6-cols-desktop">
          <div class="grid">
            <a class="icon-text has-text-link" href="/projects/example-project/board">
              <span class="icon">
                <i class="fa-solid fa-rectangle-list"></i>
              </span>

              Project Board
            </a>

        #{indent(status_buttons, 4)}
          </div>
        </div>
      HTML
    end

    define_method :indent do |str, count|
      offset = ' ' * count

      str
        .lines
        .map { |line| line.start_with?("\n") ? line : "#{offset}#{line}" }
        .join
    end

    define_method :render_button do |**options|
      button =
        Lodestone::Tasks::View::Components::StatusButton.new(task:, **options)

      pretty_render(button)
    end

    describe 'with a task with status: "Archived"' do
      let(:task_attributes) { super().merge(status: Task::Statuses::ARCHIVED) }
      let(:status_buttons) do
        <<~HTML.strip
          #{
            render_button(
              icon:   'arrow-left',
              status: Task::Statuses::DONE,
              text:   'Unarchive'
            )
          }
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with a task with status: "Done"' do
      let(:task_attributes) { super().merge(status: Task::Statuses::DONE) }
      let(:status_buttons) do
        <<~HTML.strip
          #{
            render_button(
              icon:   'arrow-left',
              status: Task::Statuses::IN_PROGRESS,
              text:   'Restart'
            )
          }
          #{
            render_button(
              icon:   'arrow-right',
              status: Task::Statuses::ARCHIVED,
              text:   'Archive'
            )
          }
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with a task with status: "Icebox"' do
      let(:task_attributes) { super().merge(status: Task::Statuses::ICEBOX) }
      let(:status_buttons) do
        <<~HTML.strip
          #{
            render_button(
              icon:   'arrow-left',
              status: Task::Statuses::WONT_DO,
              text:   'Cancel'
            )
          }
          #{
            render_button(
              icon:   'arrow-right',
              status: Task::Statuses::TO_DO,
              text:   'Prioritize'
            )
          }
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with a task with status: "In Progress"' do
      let(:task_attributes) do
        super().merge(status: Task::Statuses::IN_PROGRESS)
      end
      let(:status_buttons) do
        <<~HTML.strip
          #{
            render_button(
              icon:   'arrow-left',
              status: Task::Statuses::TO_DO,
              text:   'Stop'
            )
          }
          #{
            render_button(
              icon:   'arrow-right',
              status: Task::Statuses::DONE,
              text:   'Finish'
            )
          }
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with a task with status: "To Do"' do
      let(:task_attributes) do
        super().merge(status: Task::Statuses::TO_DO)
      end
      let(:status_buttons) do
        <<~HTML.strip
          #{
            render_button(
              icon:   'arrow-left',
              status: Task::Statuses::ICEBOX,
              text:   'Freeze'
            )
          }
          #{
            render_button(
              icon:   'arrow-right',
              status: Task::Statuses::IN_PROGRESS,
              text:   'Start'
            )
          }
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with a task with status: "Won\'t Do"' do
      let(:task_attributes) do
        super().merge(status: Task::Statuses::WONT_DO)
      end
      let(:status_buttons) do
        <<~HTML.strip
          #{
            render_button(
              icon:   'arrow-right',
              status: Task::Statuses::ICEBOX,
              text:   'Restore'
            )
          }
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end
  end
end
