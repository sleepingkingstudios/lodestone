# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Projects::View::Show, type: :component do
  subject(:component) { described_class.new(request:, resource:, result:) }

  let(:resource_options) do
    {
      components:      Lodestone::Projects::View::Components,
      title_attribute: 'name'
    }
  end
  let(:request) { Cuprum::Rails::Request.new }
  let(:resource) do
    Librum::Core::Resource.new(name: 'projects', **resource_options)
  end
  let(:result) { Cuprum::Rails::Result.new }

  describe '#call' do
    let(:rendered) { pretty_render(component) }
    let(:snapshot) do
      <<~HTML
        <h1 class="has-text-overflow-ellipsis">
          Show Project
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

    describe 'with a result with data' do
      let(:confirm_message) do
        'This will permanently delete project Example Application.\n\n' \
          'Confirm deletion?'
      end
      let(:data_attributes) do
        <<~TEXT.strip
          data-action="submit->librum-components-confirm-form#submit" data-controller="librum-components-confirm-form" data-librum-components-confirm-form-message-value="#{confirm_message}"
        TEXT
      end
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
      let(:result) { Cuprum::Rails::Result.new(value: { 'project' => data }) }
      let(:snapshot) do
        <<~HTML
          <div class="level mb-5">
            <div class="level-left level-shrink is-overflow-hidden">
              <h1 class="mb-0 has-text-overflow-ellipsis">
                Example Application
              </h1>
            </div>

            <div class="level-right">
              <div class="level-item">
                <a class="button" href="/projects/ex-app/edit">
                  <span class="icon">
                    <i class="fa-solid fa-pencil"></i>
                  </span>

                  <span>
                    Update Project
                  </span>
                </a>
              </div>

              <div class="level-item">
                <form class="is-inline-block" #{data_attributes} action="/projects/ex-app" accept-charset="UTF-8" method="post">
                  <input type="hidden" name="_method" value="delete" autocomplete="off">

                  <button class="button is-danger is-outlined" type="submit">
                    <span class="icon">
                      <i class="fa-solid fa-eraser"></i>
                    </span>

                    <span>
                      Destroy Project
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
