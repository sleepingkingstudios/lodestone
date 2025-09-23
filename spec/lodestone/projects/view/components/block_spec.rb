# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Projects::View::Components::Block, type: :component do
  subject(:component) { described_class.new(**component_options) }

  let(:component_options) { { data: } }
  let(:data)              { nil }

  describe '#call' do
    let(:rendered) { pretty_render(component) }
    let(:snapshot) do
      <<~HTML
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

    describe 'with a result with data' do
      let(:data) do
        FactoryBot.build(
          :project,
          name:         'Example Application',
          slug:         'ex-app',
          active:       true,
          public:       true,
          project_type: Project::ProjectTypes::APPLICATION,
          description:  'An example application.'
        )
      end
      let(:snapshot) do
        <<~HTML
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
                Example Application
              </div>

              <div class="cell has-text-weight-semibold">
                Active
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                True
              </div>

              <div class="cell has-text-weight-semibold">
                Public
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                True
              </div>

              <div class="cell has-text-weight-semibold">
                Project Type
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                Application
              </div>

              <div class="cell has-text-weight-semibold">
                Repository
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                example.com/projects/ex-app
              </div>
            </div>
          </div>

          <p>
            An example application.
          </p>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
