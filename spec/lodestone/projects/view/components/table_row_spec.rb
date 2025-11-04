# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Projects::View::Components::TableRow,
  type: :component \
do
  subject(:component) do
    described_class.new(**required_keywords, **component_options)
  end

  let(:component_options) do
    {
      columns:,
      data:,
      routes:
    }
  end
  let(:required_keywords) { { resource:, result: } }
  let(:columns) do
    Lodestone::Projects::View::Components::Table
      .new(
        **required_keywords,
        routes:
      )
      .send(:columns)
      .map { |hsh| Librum::Components::DataField::Definition.normalize(hsh) }
  end
  let(:data) do
    FactoryBot.build(
      :project,
      name:         'Example Application',
      slug:         'ex-app',
      active:       true,
      public:       true,
      project_type: Project::ProjectTypes::APPLICATION,
      description:  'Description for the example application.'
    )
  end
  let(:result) { Cuprum::Result.new }
  let(:resource) do
    Librum::Core::Resource.new(name: 'projects', title_attribute: 'name')
  end
  let(:routes) do
    Cuprum::Rails::Routing::PluralRoutes.new(base_path: '/projects')
  end

  describe '#call' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:confirm_message) do
      'This will permanently delete project Example Application.\n\n' \
        'Confirm deletion?'
    end
    let(:data_attributes) do
      <<~TEXT.strip
        data-action="submit->librum-components-confirm-form#submit" data-controller="librum-components-confirm-form" data-librum-components-confirm-form-message-value="#{confirm_message}"
      TEXT
    end
    # Wrap contents in a table to ensure HTML fragment is valid.
    let(:rendered) do
      "<table>#{render_component(component)}</table>"
    end
    let(:snapshot) do
      <<~HTML
        <table>
          <tbody>
            <tr class="extended-row">
              <td>
                Example Application
              </td>

              <td>
                True
              </td>

              <td>
                True
              </td>

              <td>
                Application
              </td>

              <td>
                <div class="buttons is-right is-gapless">
                  <a class="button has-text-success is-borderless is-shadowless m-0 p-0 px-1" href="/projects/ex-app/board">
                    Board
                  </a>

                  <a class="button has-text-info is-borderless is-shadowless m-0 p-0 px-1" href="/projects/ex-app">
                    Show
                  </a>

                  <a class="button has-text-warning is-borderless is-shadowless m-0 p-0 px-1" href="/projects/ex-app/edit">
                    Update
                  </a>

                  <form class="is-inline-block" #{data_attributes} action="/projects/ex-app" accept-charset="UTF-8" method="post">
                    <input type="hidden" name="_method" value="delete" autocomplete="off">

                    <button class="button has-text-danger is-borderless is-shadowless m-0 p-0 px-1" type="submit">
                      Destroy
                    </button>
                  </form>
                </div>
              </td>
            </tr>

            <tr>
              <td class="has-text-weight-light" colspan="5">
                Description for the example application.
              </td>
            </tr>
          </tbody>
        </table>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }
  end
end
