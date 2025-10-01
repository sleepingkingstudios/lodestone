# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Tasks::View::Components::Relationships::TableBody,
  type: :component \
do
  subject(:component) do
    described_class.new(**required_keywords, **component_options)
  end

  let(:required_keywords) do
    {
      resource:,
      routes:
    }
  end
  let(:component_options) do
    {
      columns:,
      data:                  [],
      inverse_relationships:,
      relationships:,
      task:
    }
  end
  let(:resource) do
    Cuprum::Rails::Resource.new(
      actions: %i[create destroy edit new update],
      name:    'task_relationships'
    )
  end
  let(:routes) do
    Cuprum::Rails::Routing::PluralRoutes.new(base_path: '/task_relationships')
  end
  let(:inverse_relationships) { [] }
  let(:relationships)         { [] }
  let(:task)                  { nil }
  let(:columns) do
    [
      {
        key:   'source_task',
        value: ->(relationship) { relationship.source_task.title }
      },
      { key: 'relationship_type' },
      {
        key:   'target_task',
        value: ->(relationship) { relationship.target_task.title }
      }
    ]
      .map { |hsh| Librum::Components::DataField::Definition.normalize(hsh) }
  end

  describe '#call' do
    # Wrap contents in a table to ensure HTML fragment is valid.
    let(:rendered) { "<table>#{render_component(component)}</table>" }
    let(:snapshot) do
      <<~HTML
        <table>
          <tbody>
            <tr>
              <td colspan="3">
                The task has no relationships.
              </td>
            </tr>
          </tbody>
        </table>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with a task' do
      let(:task) { FactoryBot.build(:task, title: 'Example Task') }

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a task with relationships' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:task)        { FactoryBot.build(:task, title: 'Example Task') }
      let(:second_task) { FactoryBot.build(:task, title: 'Second Task') }
      let(:third_task)  { FactoryBot.build(:task, title: 'Third Task') }
      let(:relationships) do
        [
          FactoryBot.build(
            :task_relationship,
            source_task:       task,
            target_task:       second_task,
            relationship_type: TaskRelationship::RelationshipTypes::DEPENDS_ON
          ),
          FactoryBot.build(
            :task_relationship,
            source_task:       task,
            target_task:       third_task,
            relationship_type: TaskRelationship::RelationshipTypes::RELATES_TO
          )
        ]
      end
      let(:snapshot) do
        <<~HTML
          <table>
            <tbody>
              <tr class="joined-rows">
                <td>
                  Example Task
                </td>

                <td>
                  depends_on
                </td>

                <td>
                  Second Task
                </td>
              </tr>

              <tr class="joined-rows">
                <td>
                  Example Task
                </td>

                <td>
                  relates_to
                </td>

                <td>
                  Third Task
                </td>
              </tr>
            </tbody>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a task with inverse relationships' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:task)        { FactoryBot.build(:task, title: 'Example Task') }
      let(:third_task)  { FactoryBot.build(:task, title: 'Third Task') }
      let(:fourth_task) { FactoryBot.build(:task, title: 'Fourth Task') }
      let(:inverse_relationships) do
        [
          FactoryBot.build(
            :task_relationship,
            source_task:       third_task,
            target_task:       task,
            relationship_type: TaskRelationship::RelationshipTypes::RELATES_TO
          ),
          FactoryBot.build(
            :task_relationship,
            source_task:       fourth_task,
            target_task:       task,
            relationship_type: TaskRelationship::RelationshipTypes::DEPENDS_ON
          )
        ]
      end
      let(:snapshot) do
        <<~HTML
          <table>
            <tbody>
              <tr class="joined-rows">
                <td>
                  Third Task
                </td>

                <td>
                  relates_to
                </td>

                <td>
                  Example Task
                </td>
              </tr>

              <tr class="joined-rows">
                <td>
                  Fourth Task
                </td>

                <td>
                  depends_on
                </td>

                <td>
                  Example Task
                </td>
              </tr>
            </tbody>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a task with relationships and inverse relationships' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:task)        { FactoryBot.build(:task, title: 'Example Task') }
      let(:second_task) { FactoryBot.build(:task, title: 'Second Task') }
      let(:third_task)  { FactoryBot.build(:task, title: 'Third Task') }
      let(:fourth_task) { FactoryBot.build(:task, title: 'Fourth Task') }
      let(:relationships) do
        [
          FactoryBot.build(
            :task_relationship,
            source_task:       task,
            target_task:       second_task,
            relationship_type: TaskRelationship::RelationshipTypes::DEPENDS_ON
          ),
          FactoryBot.build(
            :task_relationship,
            source_task:       task,
            target_task:       third_task,
            relationship_type: TaskRelationship::RelationshipTypes::RELATES_TO
          )
        ]
      end
      let(:inverse_relationships) do
        [
          FactoryBot.build(
            :task_relationship,
            source_task:       third_task,
            target_task:       task,
            relationship_type: TaskRelationship::RelationshipTypes::RELATES_TO
          ),
          FactoryBot.build(
            :task_relationship,
            source_task:       fourth_task,
            target_task:       task,
            relationship_type: TaskRelationship::RelationshipTypes::DEPENDS_ON
          )
        ]
      end
      let(:snapshot) do
        <<~HTML
          <table>
            <tbody>
              <tr class="joined-rows">
                <td>
                  Example Task
                </td>

                <td>
                  depends_on
                </td>

                <td>
                  Second Task
                </td>
              </tr>

              <tr class="joined-rows">
                <td>
                  Example Task
                </td>

                <td>
                  relates_to
                </td>

                <td>
                  Third Task
                </td>
              </tr>
            </tbody>

            <tbody>
              <tr class="joined-rows">
                <td>
                  Third Task
                </td>

                <td>
                  relates_to
                </td>

                <td>
                  Example Task
                </td>
              </tr>

              <tr class="joined-rows">
                <td>
                  Fourth Task
                </td>

                <td>
                  depends_on
                </td>

                <td>
                  Example Task
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
