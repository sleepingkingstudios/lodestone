# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Tasks::View::Components::Relationships::TableActions,
  type: :component \
do
  subject(:component) { described_class.new(**component_options) }

  let(:component_options) do
    {
      data:,
      resource:,
      routes:
    }
  end
  let(:data) do
    FactoryBot.build(
      :task_relationship,
      id:          '00000000-0000-0000-0000-000000000000',
      source_task: FactoryBot.build(
        :task,
        title: 'Source Task',
        slug:  'source_task'
      )
    )
  end
  let(:resource) do
    Librum::Core::Resource.new(name: 'task_relationships')
  end
  let(:routes) do
    Cuprum::Rails::Routing::PluralRoutes.new(
      base_path: '/tasks/:task_id/relationships'
    )
  end

  describe '#call' do
    let(:confirm_message) do
      'This will permanently delete task_relationship ' \
        '00000000-0000-0000-0000-000000000000.\n\nConfirm deletion?'
    end
    let(:data_attributes) do
      <<~TEXT.strip
        data-action="submit->librum-components-confirm-form#submit" data-controller="librum-components-confirm-form" data-librum-components-confirm-form-message-value="#{confirm_message}"
      TEXT
    end
    let(:rendered) { pretty_render(component) }
    let(:snapshot) do
      <<~HTML
        <div class="buttons is-right is-gapless">
          <a class="button has-text-info is-borderless is-shadowless mx-0 px-1 py-0" href="/tasks/source_task/relationships/00000000-0000-0000-0000-000000000000">
            Show
          </a>

          <a class="button has-text-warning is-borderless is-shadowless mx-0 px-1 py-0" href="/tasks/source_task/relationships/00000000-0000-0000-0000-000000000000/edit">
            Update
          </a>

          <form class="is-inline-block" #{data_attributes} action="/tasks/source_task/relationships/00000000-0000-0000-0000-000000000000" accept-charset="UTF-8" method="post">
            <input type="hidden" name="_method" value="delete" autocomplete="off">

            <button class="button has-text-danger is-borderless is-shadowless mx-0 px-1 py-0" type="submit">
              Destroy
            </button>
          </form>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }
  end
end
