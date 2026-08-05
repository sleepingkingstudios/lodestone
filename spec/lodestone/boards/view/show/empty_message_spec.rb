# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Boards::View::Show::EmptyMessage, type: :component do
  subject(:component) { described_class.new(**component_options) }

  let(:component_options) { {} }

  include_deferred 'should define component option', :project

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <p class="mt-5">
          There are no matching tasks.
        </p>

        <p>
          <a class="has-text-success" href="/tasks/new">
            Create Task
          </a>
        </p>
      HTML
    end

    it { expect(rendered).to match_snapshot }

    context 'with project: value' do
      let(:project) do
        FactoryBot.build(
          :project,
          name: 'Example Project',
          slug: 'example-project'
        )
      end
      let(:component_options) { super().merge(project:) }
      let(:snapshot) do
        <<~HTML
          <p class="mt-5">
            There are no matching tasks for project Example Project.
          </p>

          <p>
            <a class="has-text-success" href="/projects/example-project/tasks/new">
              Create Task
            </a>
          </p>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end
  end
end
