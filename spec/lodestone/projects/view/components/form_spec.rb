# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Projects::View::Components::Form, type: :component do
  subject(:component) { described_class.new(**component_options) }

  let(:component_options) do
    {
      resource:,
      result:,
      routes:
    }
  end
  let(:result) do
    Cuprum::Rails::Result.new(metadata: { 'action_name' => :create })
  end
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
        <form class="fixed-grid has-6-cols" action="/projects" accept-charset="UTF-8" method="post">
          <div class="grid">
            <div class="field cell is-col-span-2">
              <label class="label">
                Name
              </label>

              <div class="control">
                <input name="project[name]" class="input" type="text">
              </div>
            </div>

            <div class="field cell is-col-span-2">
              <label class="label">
                Slug
              </label>

              <div class="control">
                <input name="project[slug]" class="input" type="text">
              </div>
            </div>

            <div class="field cell is-col-span-2">
              <label class="label">
                Project Type
              </label>

              <div class="control">
                <div class="select is-block">
                  <select name="project[project_type]">
                    <option value="" selected="selected"></option>

                    <option value="application">
                      Application
                    </option>

                    <option value="library">
                      Library
                    </option>

                    <option value="script">
                      Script
                    </option>
                  </select>
                </div>
              </div>
            </div>

            <div class="field cell is-col-span-4">
              <label class="label">
                Repository
              </label>

              <div class="control">
                <input name="project[repository]" class="input" type="text">
              </div>
            </div>

            <div class="field">
              <label class="label">
                &nbsp;
              </label>

              <div class="control px-1 py-2">
                <label class="checkbox">
                  <input autocomplete="off" name="project[active]" type="hidden" value="0">

                  <input name="project[active]" type="checkbox" value="1">

                  <span class="ml-1">
                    Active
                  </span>
                </label>
              </div>
            </div>

            <div class="field">
              <label class="label">
                &nbsp;
              </label>

              <div class="control px-1 py-2">
                <label class="checkbox">
                  <input autocomplete="off" name="project[public]" type="hidden" value="0">

                  <input name="project[public]" type="checkbox" value="1">

                  <span class="ml-1">
                    Public
                  </span>
                </label>
              </div>
            </div>

            <div class="field cell is-col-span-6">
              <label class="label">
                Description
              </label>

              <div class="control">
                <textarea name="project[description]" class="textarea"></textarea>
              </div>
            </div>

            <div class="field is-grouped cell is-col-span-6">
              <p class="control">
                <button class="button is-link" type="submit">
                  <span class="icon">
                    <i class="fa-solid fa-plus"></i>
                  </span>

                  <span>
                    Create Project
                  </span>
                </button>
              </p>

              <p class="control">
                <a class="button" href="/projects">
                  Cancel
                </a>
              </p>
            </div>
          </div>
        </form>
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
      let(:result) do
        Cuprum::Rails::Result.new(
          **super().properties,
          value: { 'project' => data }
        )
      end
      let(:snapshot) do
        <<~HTML
          <form class="fixed-grid has-6-cols" action="/projects" accept-charset="UTF-8" method="post">
            <div class="grid">
              <div class="field cell is-col-span-2">
                <label class="label">
                  Name
                </label>

                <div class="control">
                  <input name="project[name]" class="input" type="text" value="Example Application">
                </div>
              </div>

              <div class="field cell is-col-span-2">
                <label class="label">
                  Slug
                </label>

                <div class="control">
                  <input name="project[slug]" class="input" type="text" value="ex-app">
                </div>
              </div>

              <div class="field cell is-col-span-2">
                <label class="label">
                  Project Type
                </label>

                <div class="control">
                  <div class="select is-block">
                    <select name="project[project_type]">
                      <option value=""></option>

                      <option value="application" selected="selected">
                        Application
                      </option>

                      <option value="library">
                        Library
                      </option>

                      <option value="script">
                        Script
                      </option>
                    </select>
                  </div>
                </div>
              </div>

              <div class="field cell is-col-span-4">
                <label class="label">
                  Repository
                </label>

                <div class="control">
                  <input name="project[repository]" class="input" type="text" value="example.com/projects/ex-app">
                </div>
              </div>

              <div class="field">
                <label class="label">
                  &nbsp;
                </label>

                <div class="control px-1 py-2">
                  <label class="checkbox">
                    <input autocomplete="off" name="project[active]" type="hidden" value="0">

                    <input name="project[active]" type="checkbox" checked="checked" value="1">

                    <span class="ml-1">
                      Active
                    </span>
                  </label>
                </div>
              </div>

              <div class="field">
                <label class="label">
                  &nbsp;
                </label>

                <div class="control px-1 py-2">
                  <label class="checkbox">
                    <input autocomplete="off" name="project[public]" type="hidden" value="0">

                    <input name="project[public]" type="checkbox" checked="checked" value="1">

                    <span class="ml-1">
                      Public
                    </span>
                  </label>
                </div>
              </div>

              <div class="field cell is-col-span-6">
                <label class="label">
                  Description
                </label>

                <div class="control">
                  <textarea name="project[description]" class="textarea">
                    An example application.
                  </textarea>
                </div>
              </div>

              <div class="field is-grouped cell is-col-span-6">
                <p class="control">
                  <button class="button is-link" type="submit">
                    <span class="icon">
                      <i class="fa-solid fa-plus"></i>
                    </span>

                    <span>
                      Create Project
                    </span>
                  </button>
                </p>

                <p class="control">
                  <a class="button" href="/projects">
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

    describe 'with a result with data and errors' do
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
      let(:errors) do
        Stannum::Errors.new.tap do |err|
          err['project']['name'].add('taken', message: 'is taken')
          err['project']['project_type'].add('full', message: 'is full')
        end
      end
      let(:result) do
        Cuprum::Rails::Result.new(
          **super().properties,
          value: { 'project' => data },
          error: Struct.new(:errors).new(errors)
        )
      end
      let(:snapshot) do
        <<~HTML
          <form class="fixed-grid has-6-cols" action="/projects" accept-charset="UTF-8" method="post">
            <div class="grid">
              <div class="field cell is-col-span-2">
                <label class="label">
                  Name
                </label>

                <div class="control has-icons-right">
                  <input name="project[name]" class="input is-danger" type="text" value="Example Application">

                  <span class="icon is-small is-right">
                    <i class="fa-solid fa-exclamation-triangle"></i>
                  </span>
                </div>

                <p class="help is-danger">
                  is taken
                </p>
              </div>

              <div class="field cell is-col-span-2">
                <label class="label">
                  Slug
                </label>

                <div class="control">
                  <input name="project[slug]" class="input" type="text" value="ex-app">
                </div>
              </div>

              <div class="field cell is-col-span-2">
                <label class="label">
                  Project Type
                </label>

                <div class="control">
                  <div class="select is-danger is-block">
                    <select name="project[project_type]">
                      <option value=""></option>

                      <option value="application" selected="selected">
                        Application
                      </option>

                      <option value="library">
                        Library
                      </option>

                      <option value="script">
                        Script
                      </option>
                    </select>
                  </div>
                </div>

                <p class="help is-danger">
                  is full
                </p>
              </div>

              <div class="field cell is-col-span-4">
                <label class="label">
                  Repository
                </label>

                <div class="control">
                  <input name="project[repository]" class="input" type="text" value="example.com/projects/ex-app">
                </div>
              </div>

              <div class="field">
                <label class="label">
                  &nbsp;
                </label>

                <div class="control px-1 py-2">
                  <label class="checkbox">
                    <input autocomplete="off" name="project[active]" type="hidden" value="0">

                    <input name="project[active]" type="checkbox" checked="checked" value="1">

                    <span class="ml-1">
                      Active
                    </span>
                  </label>
                </div>
              </div>

              <div class="field">
                <label class="label">
                  &nbsp;
                </label>

                <div class="control px-1 py-2">
                  <label class="checkbox">
                    <input autocomplete="off" name="project[public]" type="hidden" value="0">

                    <input name="project[public]" type="checkbox" checked="checked" value="1">

                    <span class="ml-1">
                      Public
                    </span>
                  </label>
                </div>
              </div>

              <div class="field cell is-col-span-6">
                <label class="label">
                  Description
                </label>

                <div class="control">
                  <textarea name="project[description]" class="textarea">
                    An example application.
                  </textarea>
                </div>
              </div>

              <div class="field is-grouped cell is-col-span-6">
                <p class="control">
                  <button class="button is-link" type="submit">
                    <span class="icon">
                      <i class="fa-solid fa-plus"></i>
                    </span>

                    <span>
                      Create Project
                    </span>
                  </button>
                </p>

                <p class="control">
                  <a class="button" href="/projects">
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
