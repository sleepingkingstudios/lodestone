# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Tasks::View::Components::Block, type: :component do
  subject(:component) do
    described_class.new(**required_keywords, **component_options)
  end

  let(:component_options) { { data: } }
  let(:required_keywords) { { result: } }
  let(:data)              { nil }
  let(:result)            { Cuprum::Result.new }

  describe '#call' do
    let(:rendered) { pretty_render(component) }
    let(:snapshot) do
      <<~HTML
        <div class="fixed-grid has-0-cols has-4-cols-tablet has-6-cols-desktop">
          <div class="grid">
            <div class="cell has-text-weight-semibold">
              Slug
            </div>

            <div class="cell is-col-span-3 is-col-span-5-desktop">
              &nbsp;
            </div>

            <div class="cell has-text-weight-semibold">
              Project
            </div>

            <div class="cell is-col-span-3 is-col-span-5-desktop"></div>

            <div class="cell has-text-weight-semibold">
              Task Type
            </div>

            <div class="cell is-col-span-3 is-col-span-5-desktop">
              &nbsp;
            </div>

            <div class="cell has-text-weight-semibold">
              Status
            </div>

            <div class="cell is-col-span-3 is-col-span-5-desktop"></div>
          </div>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with a result with data' do
      let(:project) do
        FactoryBot.build(
          :project,
          name: 'Example Application',
          slug: 'ex-app'
        )
      end
      let(:data) do
        FactoryBot.build(
          :task,
          project:,
          title:     'Investigate Mystery',
          slug:      'investigate-mystery',
          status:    Task::Statuses::TO_DO,
          task_type: Task::TaskTypes::INVESTIGATION
        )
      end
      let(:snapshot) do
        <<~HTML
          <div class="fixed-grid has-0-cols has-4-cols-tablet has-6-cols-desktop">
            <div class="grid">
              <div class="cell has-text-weight-semibold">
                Slug
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                investigate-mystery
              </div>

              <div class="cell has-text-weight-semibold">
                Project
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                <a href="/projects/ex-app">
                  Example Application
                </a>
              </div>

              <div class="cell has-text-weight-semibold">
                Task Type
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                Investigation
              </div>

              <div class="cell has-text-weight-semibold">
                Status
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                To Do
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
