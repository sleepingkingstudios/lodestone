# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::TaskRelationships::View::Components::Form,
  type: :component \
do
  subject(:component) { described_class.new(**component_options) }

  let(:component_options) do
    {
      resource:,
      result:,
      routes:
    }
  end
  let(:action_name) { :create }
  let(:result) do
    Cuprum::Rails::Result.new(metadata: { 'action_name' => action_name })
  end
  let(:resource) do
    Cuprum::Rails::Resource.new(name: 'tasks')
  end
  let(:routes) do
    Cuprum::Rails::Routing::PluralRoutes.new(base_path: '/tasks')
  end

  describe '#call' do
    let(:rendered) { pretty_render(component) }

    describe 'with action_name: :create' do
      let(:action_name) { :create }
      let(:snapshot) do
        <<~HTML
          <form class="fixed-grid has-3-cols" action="/tasks" accept-charset="UTF-8" method="post">
            <div class="grid">
              <input name="task_relationship[source_task_id]" class="input" type="hidden">

              <div class="field">
                <label class="label">
                  Source Task
                </label>

                <div class="control">
                  <input name="task_relationship[source_task_id]" class="input" disabled="disabled" type="text" value=" ">
                </div>
              </div>

              <div class="field">
                <label class="label">
                  Relationship Type
                </label>

                <div class="control">
                  <div class="select is-block">
                    <select name="task_relationship[relationship_type]">
                      <option value="belongs_to">
                        Belongs To
                      </option>

                      <option value="depends_on">
                        Depends On
                      </option>

                      <option value="merged_into">
                        Merged Into
                      </option>

                      <option value="relates_to">
                        Relates To
                      </option>
                    </select>
                  </div>
                </div>
              </div>

              <div class="field">
                <label class="label">
                  Target Task
                </label>

                <div class="control">
                  <div class="select is-block">
                    <select name="task_relationship[target_task_id]">
                      <option value="" selected="selected">
                        &nbsp;
                      </option>
                    </select>
                  </div>
                </div>
              </div>

              <div class="field is-grouped cell is-col-span-3">
                <p class="control">
                  <button class="button is-link" type="submit">
                    <span class="icon">
                      <i class="fa-solid fa-plus"></i>
                    </span>

                    <span>
                      Create Relationship
                    </span>
                  </button>
                </p>

                <p class="control">
                  <a class="button" href="/tasks">
                    Cancel
                  </a>
                </p>
              </div>
            </div>
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with data' do
        let(:source_task) do
          FactoryBot.build(
            :task,
            id:    '00000000-0000-0000-0000-000000000001',
            title: 'Source Task',
            slug:  'source-task'
          )
        end
        let(:tasks) do
          {
            'Example Application' => [
              FactoryBot.build(
                :task,
                id:    '00000000-0000-0000-0000-000000000002',
                title: 'Second Task',
                slug:  'second-task'
              ),
              FactoryBot.build(
                :task,
                id:    '00000000-0000-0000-0000-000000000003',
                title: 'Third Task',
                slug:  'third-task'
              )
            ],
            'Example Library'     => [
              FactoryBot.build(
                :task,
                id:    '00000000-0000-0000-0000-000000000004',
                title: 'Fourth Task',
                slug:  'fourth-task'
              )
            ],
            'Example Script'      => []
          }
        end
        let(:task_relationship) do
          FactoryBot.build(
            :task_relationship,
            relationship_type: TaskRelationship::RelationshipTypes::DEPENDS_ON,
            source_task:
          )
        end
        let(:result) do
          Cuprum::Rails::Result.new(
            **super().properties,
            value: {
              'source_task'       => source_task,
              'tasks'             => tasks,
              'task_relationship' => task_relationship
            }
          )
        end
        let(:snapshot) do
          <<~HTML
            <form class="fixed-grid has-3-cols" action="/tasks" accept-charset="UTF-8" method="post">
              <div class="grid">
                <input name="task_relationship[source_task_id]" class="input" type="hidden" value="00000000-0000-0000-0000-000000000001">

                <div class="field">
                  <label class="label">
                    Source Task
                  </label>

                  <div class="control">
                    <input name="task_relationship[source_task_id]" class="input" disabled="disabled" type="text" value="Source Task (source-task)">
                  </div>
                </div>

                <div class="field">
                  <label class="label">
                    Relationship Type
                  </label>

                  <div class="control">
                    <div class="select is-block">
                      <select name="task_relationship[relationship_type]">
                        <option value="belongs_to">
                          Belongs To
                        </option>

                        <option value="depends_on" selected="selected">
                          Depends On
                        </option>

                        <option value="merged_into">
                          Merged Into
                        </option>

                        <option value="relates_to">
                          Relates To
                        </option>
                      </select>
                    </div>
                  </div>
                </div>

                <div class="field">
                  <label class="label">
                    Target Task
                  </label>

                  <div class="control">
                    <div class="select is-block">
                      <select name="task_relationship[target_task_id]">
                        <option value="" selected="selected">
                          &nbsp;
                        </option>

                        <optgroup label="Example Application">
                          <option value="00000000-0000-0000-0000-000000000002">
                            Second Task (second-task)
                          </option>

                          <option value="00000000-0000-0000-0000-000000000003">
                            Third Task (third-task)
                          </option>
                        </optgroup>

                        <optgroup label="Example Library">
                          <option value="00000000-0000-0000-0000-000000000004">
                            Fourth Task (fourth-task)
                          </option>
                        </optgroup>
                      </select>
                    </div>
                  </div>
                </div>

                <div class="field is-grouped cell is-col-span-3">
                  <p class="control">
                    <button class="button is-link" type="submit">
                      <span class="icon">
                        <i class="fa-solid fa-plus"></i>
                      </span>

                      <span>
                        Create Relationship
                      </span>
                    </button>
                  </p>

                  <p class="control">
                    <a class="button" href="/tasks/source-task">
                      Cancel
                    </a>
                  </p>
                </div>
              </div>
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with data and errors' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:source_task) do
          FactoryBot.build(
            :task,
            id:    '00000000-0000-0000-0000-000000000001',
            title: 'Source Task',
            slug:  'source-task'
          )
        end
        let(:tasks) do
          {
            'Example Application' => [
              FactoryBot.build(
                :task,
                id:    '00000000-0000-0000-0000-000000000002',
                title: 'Second Task',
                slug:  'second-task'
              ),
              FactoryBot.build(
                :task,
                id:    '00000000-0000-0000-0000-000000000003',
                title: 'Third Task',
                slug:  'third-task'
              )
            ],
            'Example Library'     => [
              FactoryBot.build(
                :task,
                id:    '00000000-0000-0000-0000-000000000004',
                title: 'Fourth Task',
                slug:  'fourth-task'
              )
            ],
            'Example Script'      => []
          }
        end
        let(:task_relationship) do
          FactoryBot.build(
            :task_relationship,
            relationship_type: TaskRelationship::RelationshipTypes::DEPENDS_ON,
            source_task:
          )
        end
        let(:errors) do
          Stannum::Errors.new.tap do |err|
            err['task_relationship']['relationship_type']
              .add('taken', message: 'is taken')
            err['task_relationship']['target_task_id']
              .add('empty', message: 'is empty')
          end
        end
        let(:result) do
          Cuprum::Rails::Result.new(
            **super().properties,
            value: {
              'source_task'       => source_task,
              'tasks'             => tasks,
              'task_relationship' => task_relationship
            },
            error: Struct.new(:errors).new(errors)
          )
        end
        let(:snapshot) do
          <<~HTML
            <form class="fixed-grid has-3-cols" action="/tasks" accept-charset="UTF-8" method="post">
              <div class="grid">
                <input name="task_relationship[source_task_id]" class="input" type="hidden" value="00000000-0000-0000-0000-000000000001">

                <div class="field">
                  <label class="label">
                    Source Task
                  </label>

                  <div class="control">
                    <input name="task_relationship[source_task_id]" class="input" disabled="disabled" type="text" value="Source Task (source-task)">
                  </div>
                </div>

                <div class="field">
                  <label class="label">
                    Relationship Type
                  </label>

                  <div class="control">
                    <div class="select is-danger is-block">
                      <select name="task_relationship[relationship_type]">
                        <option value="belongs_to">
                          Belongs To
                        </option>

                        <option value="depends_on" selected="selected">
                          Depends On
                        </option>

                        <option value="merged_into">
                          Merged Into
                        </option>

                        <option value="relates_to">
                          Relates To
                        </option>
                      </select>
                    </div>
                  </div>

                  <p class="help is-danger">
                    is taken
                  </p>
                </div>

                <div class="field">
                  <label class="label">
                    Target Task
                  </label>

                  <div class="control">
                    <div class="select is-danger is-block">
                      <select name="task_relationship[target_task_id]">
                        <option value="" selected="selected">
                          &nbsp;
                        </option>

                        <optgroup label="Example Application">
                          <option value="00000000-0000-0000-0000-000000000002">
                            Second Task (second-task)
                          </option>

                          <option value="00000000-0000-0000-0000-000000000003">
                            Third Task (third-task)
                          </option>
                        </optgroup>

                        <optgroup label="Example Library">
                          <option value="00000000-0000-0000-0000-000000000004">
                            Fourth Task (fourth-task)
                          </option>
                        </optgroup>
                      </select>
                    </div>
                  </div>

                  <p class="help is-danger">
                    is empty
                  </p>
                </div>

                <div class="field is-grouped cell is-col-span-3">
                  <p class="control">
                    <button class="button is-link" type="submit">
                      <span class="icon">
                        <i class="fa-solid fa-plus"></i>
                      </span>

                      <span>
                        Create Relationship
                      </span>
                    </button>
                  </p>

                  <p class="control">
                    <a class="button" href="/tasks/source-task">
                      Cancel
                    </a>
                  </p>
                </div>
              </div>
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with action_name: :update' do
      let(:action_name) { :update }
      let(:routes) do
        super().with_wildcards({ id: '00000000-0000-0000-0000-000000000000' })
      end
      let(:snapshot) do
        <<~HTML
          <form class="fixed-grid has-3-cols" action="/tasks/00000000-0000-0000-0000-000000000000" accept-charset="UTF-8" method="post">
            <input type="hidden" name="_method" value="patch" autocomplete="off">

            <div class="grid">
              <input name="task_relationship[source_task_id]" class="input" type="hidden">

              <div class="field">
                <label class="label">
                  Source Task
                </label>

                <div class="control">
                  <input name="task_relationship[source_task_id]" class="input" disabled="disabled" type="text" value=" ">
                </div>
              </div>

              <div class="field">
                <label class="label">
                  Relationship Type
                </label>

                <div class="control">
                  <div class="select is-block">
                    <select name="task_relationship[relationship_type]">
                      <option value="belongs_to">
                        Belongs To
                      </option>

                      <option value="depends_on">
                        Depends On
                      </option>

                      <option value="merged_into">
                        Merged Into
                      </option>

                      <option value="relates_to">
                        Relates To
                      </option>
                    </select>
                  </div>
                </div>
              </div>

              <div class="field">
                <label class="label">
                  Target Task
                </label>

                <div class="control">
                  <div class="select is-block">
                    <select name="task_relationship[target_task_id]">
                      <option value="" selected="selected">
                        &nbsp;
                      </option>
                    </select>
                  </div>
                </div>
              </div>

              <div class="field is-grouped cell is-col-span-3">
                <p class="control">
                  <button class="button is-link" type="submit">
                    <span class="icon">
                      <i class="fa-solid fa-pencil"></i>
                    </span>

                    <span>
                      Update Relationship
                    </span>
                  </button>
                </p>

                <p class="control">
                  <a class="button" href="/tasks">
                    Cancel
                  </a>
                </p>
              </div>
            </div>
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with data' do
        let(:source_task) do
          FactoryBot.build(
            :task,
            id:    '00000000-0000-0000-0000-000000000001',
            title: 'Source Task',
            slug:  'source-task'
          )
        end
        let(:tasks) do
          {
            'Example Application' => [
              FactoryBot.build(
                :task,
                id:    '00000000-0000-0000-0000-000000000002',
                title: 'Second Task',
                slug:  'second-task'
              ),
              FactoryBot.build(
                :task,
                id:    '00000000-0000-0000-0000-000000000003',
                title: 'Third Task',
                slug:  'third-task'
              )
            ],
            'Example Library'     => [
              FactoryBot.build(
                :task,
                id:    '00000000-0000-0000-0000-000000000004',
                title: 'Fourth Task',
                slug:  'fourth-task'
              )
            ],
            'Example Script'      => []
          }
        end
        let(:task_relationship) do
          FactoryBot.build(
            :task_relationship,
            relationship_type: TaskRelationship::RelationshipTypes::DEPENDS_ON,
            source_task:,
            target_task:       tasks['Example Application'].last
          )
        end
        let(:result) do
          Cuprum::Rails::Result.new(
            **super().properties,
            value: {
              'source_task'       => source_task,
              'tasks'             => tasks,
              'task_relationship' => task_relationship
            }
          )
        end
        let(:snapshot) do
          <<~HTML
            <form class="fixed-grid has-3-cols" action="/tasks/00000000-0000-0000-0000-000000000000" accept-charset="UTF-8" method="post">
              <input type="hidden" name="_method" value="patch" autocomplete="off">

              <div class="grid">
                <input name="task_relationship[source_task_id]" class="input" type="hidden" value="00000000-0000-0000-0000-000000000001">

                <div class="field">
                  <label class="label">
                    Source Task
                  </label>

                  <div class="control">
                    <input name="task_relationship[source_task_id]" class="input" disabled="disabled" type="text" value="Source Task (source-task)">
                  </div>
                </div>

                <div class="field">
                  <label class="label">
                    Relationship Type
                  </label>

                  <div class="control">
                    <div class="select is-block">
                      <select name="task_relationship[relationship_type]">
                        <option value="belongs_to">
                          Belongs To
                        </option>

                        <option value="depends_on" selected="selected">
                          Depends On
                        </option>

                        <option value="merged_into">
                          Merged Into
                        </option>

                        <option value="relates_to">
                          Relates To
                        </option>
                      </select>
                    </div>
                  </div>
                </div>

                <div class="field">
                  <label class="label">
                    Target Task
                  </label>

                  <div class="control">
                    <div class="select is-block">
                      <select name="task_relationship[target_task_id]">
                        <option value="">
                          &nbsp;
                        </option>

                        <optgroup label="Example Application">
                          <option value="00000000-0000-0000-0000-000000000002">
                            Second Task (second-task)
                          </option>

                          <option value="00000000-0000-0000-0000-000000000003" selected="selected">
                            Third Task (third-task)
                          </option>
                        </optgroup>

                        <optgroup label="Example Library">
                          <option value="00000000-0000-0000-0000-000000000004">
                            Fourth Task (fourth-task)
                          </option>
                        </optgroup>
                      </select>
                    </div>
                  </div>
                </div>

                <div class="field is-grouped cell is-col-span-3">
                  <p class="control">
                    <button class="button is-link" type="submit">
                      <span class="icon">
                        <i class="fa-solid fa-pencil"></i>
                      </span>

                      <span>
                        Update Relationship
                      </span>
                    </button>
                  </p>

                  <p class="control">
                    <a class="button" href="/tasks/source-task">
                      Cancel
                    </a>
                  </p>
                </div>
              </div>
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with data and errors' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:source_task) do
          FactoryBot.build(
            :task,
            id:    '00000000-0000-0000-0000-000000000001',
            title: 'Source Task',
            slug:  'source-task'
          )
        end
        let(:tasks) do
          {
            'Example Application' => [
              FactoryBot.build(
                :task,
                id:    '00000000-0000-0000-0000-000000000002',
                title: 'Second Task',
                slug:  'second-task'
              ),
              FactoryBot.build(
                :task,
                id:    '00000000-0000-0000-0000-000000000003',
                title: 'Third Task',
                slug:  'third-task'
              )
            ],
            'Example Library'     => [
              FactoryBot.build(
                :task,
                id:    '00000000-0000-0000-0000-000000000004',
                title: 'Fourth Task',
                slug:  'fourth-task'
              )
            ],
            'Example Script'      => []
          }
        end
        let(:task_relationship) do
          FactoryBot.build(
            :task_relationship,
            relationship_type: TaskRelationship::RelationshipTypes::DEPENDS_ON,
            source_task:,
            target_task:       tasks['Example Application'].last
          )
        end
        let(:errors) do
          Stannum::Errors.new.tap do |err|
            err['task_relationship']['relationship_type']
              .add('taken', message: 'is taken')
            err['task_relationship']['target_task_id']
              .add('empty', message: 'is empty')
          end
        end
        let(:result) do
          Cuprum::Rails::Result.new(
            **super().properties,
            value: {
              'source_task'       => source_task,
              'tasks'             => tasks,
              'task_relationship' => task_relationship
            },
            error: Struct.new(:errors).new(errors)
          )
        end
        let(:snapshot) do
          <<~HTML
            <form class="fixed-grid has-3-cols" action="/tasks/00000000-0000-0000-0000-000000000000" accept-charset="UTF-8" method="post">
              <input type="hidden" name="_method" value="patch" autocomplete="off">

              <div class="grid">
                <input name="task_relationship[source_task_id]" class="input" type="hidden" value="00000000-0000-0000-0000-000000000001">

                <div class="field">
                  <label class="label">
                    Source Task
                  </label>

                  <div class="control">
                    <input name="task_relationship[source_task_id]" class="input" disabled="disabled" type="text" value="Source Task (source-task)">
                  </div>
                </div>

                <div class="field">
                  <label class="label">
                    Relationship Type
                  </label>

                  <div class="control">
                    <div class="select is-danger is-block">
                      <select name="task_relationship[relationship_type]">
                        <option value="belongs_to">
                          Belongs To
                        </option>

                        <option value="depends_on" selected="selected">
                          Depends On
                        </option>

                        <option value="merged_into">
                          Merged Into
                        </option>

                        <option value="relates_to">
                          Relates To
                        </option>
                      </select>
                    </div>
                  </div>

                  <p class="help is-danger">
                    is taken
                  </p>
                </div>

                <div class="field">
                  <label class="label">
                    Target Task
                  </label>

                  <div class="control">
                    <div class="select is-danger is-block">
                      <select name="task_relationship[target_task_id]">
                        <option value="">
                          &nbsp;
                        </option>

                        <optgroup label="Example Application">
                          <option value="00000000-0000-0000-0000-000000000002">
                            Second Task (second-task)
                          </option>

                          <option value="00000000-0000-0000-0000-000000000003" selected="selected">
                            Third Task (third-task)
                          </option>
                        </optgroup>

                        <optgroup label="Example Library">
                          <option value="00000000-0000-0000-0000-000000000004">
                            Fourth Task (fourth-task)
                          </option>
                        </optgroup>
                      </select>
                    </div>
                  </div>

                  <p class="help is-danger">
                    is empty
                  </p>
                </div>

                <div class="field is-grouped cell is-col-span-3">
                  <p class="control">
                    <button class="button is-link" type="submit">
                      <span class="icon">
                        <i class="fa-solid fa-pencil"></i>
                      </span>

                      <span>
                        Update Relationship
                      </span>
                    </button>
                  </p>

                  <p class="control">
                    <a class="button" href="/tasks/source-task">
                      Cancel
                    </a>
                  </p>
                </div>
              </div>
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end
end
