# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Projects::View::Components::TableActions,
  type: :component \
do
  include Librum::Components::RSpec::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:component_options) do
    {
      data:,
      resource:,
      routes:
    }
  end
  let(:data) { { 'slug' => 'example-project' } }
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
        <div class="buttons is-right is-gapless">
          <a class="button has-text-success is-borderless is-shadowless mx-0 px-1 py-0" href="/projects/example-project/board">Board</a>

          <a class="button has-text-info is-borderless is-shadowless mx-0 px-1 py-0" href="/projects/example-project">Show</a>

          <a class="button has-text-warning is-borderless is-shadowless mx-0 px-1 py-0" href="/projects/example-project/edit">Update</a>

          <form class="is-inline-block" action="/projects/example-project" accept-charset="UTF-8" method="post">
            <input type="hidden" name="_method" value="delete" autocomplete="off">

            <button class="button has-text-danger is-borderless is-shadowless mx-0 px-1 py-0" type="submit">Destroy</button>
          </form>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }
  end
end
