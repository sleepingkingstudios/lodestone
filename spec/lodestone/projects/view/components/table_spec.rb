# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Projects::View::Components::Table, type: :component do
  include Librum::Components::RSpec::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:component_options) do
    {
      data:,
      resource:,
      routes:
    }
  end
  let(:data) { [] }
  let(:resource) do
    Cuprum::Rails::Resource.new(name: 'projects')
  end
  let(:routes) do
    Cuprum::Rails::Routing::PluralRoutes.new(base_path: '/projects')
  end

  describe '#call' do
    let(:rendered) { pretty_render(component) }
    let(:snapshot) do
      <<~HTML
        <table class="table is-fullwidth">
          <thead>
            <tr>
              <th>Name</th>

              <th>Active</th>

              <th>Public</th>

              <th>Project Type</th>

              <th> </th>
            </tr>
          </thead>

          <tbody>
            <tr>
              <td colspan="5">
                There are no projects matching the criteria.
              </td>
            </tr>
          </tbody>
        </table>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with data' do
      let(:data) do
        [
          FactoryBot.build(
            :project,
            name:         'Example Application',
            slug:         'ex-app',
            active:       true,
            public:       true,
            project_type: Project::ProjectTypes::APPLICATION
          ),
          FactoryBot.build(
            :project,
            name:         'Secret Library',
            slug:         'secret',
            active:       true,
            public:       false,
            project_type: Project::ProjectTypes::LIBRARY
          ),
          FactoryBot.build(
            :project,
            name:         'Deprecated Script',
            slug:         'dps',
            active:       false,
            public:       true,
            project_type: Project::ProjectTypes::SCRIPT
          )
        ]
      end
      let(:snapshot) do
        <<~HTML
          <table class="table is-fullwidth">
            <thead>
              <tr>
                <th>Name</th>

                <th>Active</th>

                <th>Public</th>

                <th>Project Type</th>

                <th> </th>
              </tr>
            </thead>

            <tbody>
              <tr>
                <td>Example Application</td>

                <td>True</td>

                <td>True</td>

                <td>Application</td>

                <td>
                  <div class="buttons is-right is-gapless">
                    <a class="button has-text-success is-borderless is-shadowless mx-0 px-1 py-0" href="/projects/ex-app/board">Board</a>

                    <a class="button has-text-info is-borderless is-shadowless mx-0 px-1 py-0" href="/projects/ex-app">Show</a>

                    <a class="button has-text-warning is-borderless is-shadowless mx-0 px-1 py-0" href="/projects/ex-app/edit">Update</a>

                    <form class="is-inline-block" action="/projects/ex-app" accept-charset="UTF-8" method="post">
                      <input type="hidden" name="_method" value="delete" autocomplete="off">

                      <button class="button has-text-danger is-borderless is-shadowless mx-0 px-1 py-0" type="submit">Destroy</button>
                    </form>
                  </div>
                </td>
              </tr>

              <tr>
                <td>Secret Library</td>

                <td>True</td>

                <td>False</td>

                <td>Library</td>

                <td>
                  <div class="buttons is-right is-gapless">
                    <a class="button has-text-success is-borderless is-shadowless mx-0 px-1 py-0" href="/projects/secret/board">Board</a>

                    <a class="button has-text-info is-borderless is-shadowless mx-0 px-1 py-0" href="/projects/secret">Show</a>

                    <a class="button has-text-warning is-borderless is-shadowless mx-0 px-1 py-0" href="/projects/secret/edit">Update</a>

                    <form class="is-inline-block" action="/projects/secret" accept-charset="UTF-8" method="post">
                      <input type="hidden" name="_method" value="delete" autocomplete="off">

                      <button class="button has-text-danger is-borderless is-shadowless mx-0 px-1 py-0" type="submit">Destroy</button>
                    </form>
                  </div>
                </td>
              </tr>

              <tr>
                <td>Deprecated Script</td>

                <td>False</td>

                <td>True</td>

                <td>Script</td>

                <td>
                  <div class="buttons is-right is-gapless">
                    <a class="button has-text-success is-borderless is-shadowless mx-0 px-1 py-0" href="/projects/dps/board">Board</a>

                    <a class="button has-text-info is-borderless is-shadowless mx-0 px-1 py-0" href="/projects/dps">Show</a>

                    <a class="button has-text-warning is-borderless is-shadowless mx-0 px-1 py-0" href="/projects/dps/edit">Update</a>

                    <form class="is-inline-block" action="/projects/dps" accept-charset="UTF-8" method="post">
                      <input type="hidden" name="_method" value="delete" autocomplete="off">

                      <button class="button has-text-danger is-borderless is-shadowless mx-0 px-1 py-0" type="submit">Destroy</button>
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
