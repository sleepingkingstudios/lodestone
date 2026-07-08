# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Tasks::View::Components::StatusButton,
  type: :component \
do
  subject(:component) { described_class.new(**component_options) }

  let(:task) do
    FactoryBot.create(:task, :done, :with_project, slug: 'example-task')
  end
  let(:component_options) do
    {
      icon:   'radiation',
      status: Task::Statuses::ARCHIVED,
      task:,
      text:   'Irradiate'
    }
  end

  include_deferred 'should define component option', :icon

  include_deferred 'should define component option', :status

  include_deferred 'should define component option', :task

  include_deferred 'should define component option', :text

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <form action="/tasks/example-task/status" accept-charset="UTF-8" method="post">
          <input type="hidden" name="_method" value="patch" autocomplete="off">

          <input value="archived" autocomplete="off" type="hidden" name="task[status]" id="task_status">

          <button class="button px-2 py-0 is-borderless is-shadowless" type="submit">
            <span class="icon">
              <i class="fa-solid fa-radiation"></i>
            </span>

            <span>
              Irradiate Task
            </span>
          </button>
        </form>
      HTML
    end

    it { expect(rendered).to match_snapshot }
  end
end
