# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::View::Layouts::Page, type: :component do
  subject(:component) do
    described_class.new(**component_options).with_content(content)
  end

  let(:content) do
    html_content = <<~HTML
      <h1>Greetings, Starfighter!</h1>

      <p>
        You have been recruited by the Star League to defend the frontier
        against Xur and the Ko-Dan Armada!
      </p>
    HTML

    Librum::Components::Literal.new(html_content).call
  end

  describe '#call' do
    let(:rendered) { render_component(component) }
    let(:snapshot) do
      <<~HTML
        <nav class="navbar is-success" role="navigation" aria-label="main navigation" data-controller="librum-components-navbar">
          <div class="container is-max-widescreen">
            <div class="navbar-brand">
              <a class="navbar-item" href="/">
                <span class="icon">
                  <i class="fa-solid fa-compass fa-2xl"></i>
                </span>

                <span class="title is-size-4">
                  Lodestone
                </span>
              </a>

              <a role="button" class="navbar-burger" aria-label="menu" aria-expanded="false" data-action="click->librum-components-navbar#toggle" data-librum-components-navbar-target="button">
                <span aria-hidden="true"></span>

                <span aria-hidden="true"></span>

                <span aria-hidden="true"></span>

                <span aria-hidden="true"></span>
              </a>
            </div>
          </div>
        </nav>

        <main class="section" style="flex: 1;">
          <div class="container content is-max-widescreen">
            <h1>
              Greetings, Starfighter!
            </h1>

            <p>
              You have been recruited by the Star League to defend the frontier
              against Xur and the Ko-Dan Armada!
            </p>
          </div>
        </main>

        <footer>
          <div class="footer">
            <div class="container is-max-widescreen">
              <p class="has-text-centered">
                <span class="icon-text">
                  Sleeping&nbsp;King&nbsp;Studios is

                  <span class="icon">
                    <i class="fa-solid fa-copyright"></i>
                  </span>

                  Rob&nbsp;Smith 2021-2025
                </span>
              </p>

              <p class="has-text-centered is-italic mt-1">
                Non&nbsp;Sufficit&nbsp;Orbis
              </p>
            </div>
          </div>
        </footer>
      HTML
    end

    it { expect(rendered).to match_snapshot }

    describe 'with session: a user session' do
      let(:user) do
        Librum::Iam::User.new(username: 'Alan Bradley')
      end
      let(:credential) do
        Librum::Iam::Credential.new(user:, expires_at: 1.day.from_now)
      end
      let(:session) do
        Librum::Iam::Session.new(credential:)
      end
      let(:component_options) do
        super().merge(session:)
      end
      let(:snapshot) do
        <<~HTML
          <nav class="navbar is-success" role="navigation" aria-label="main navigation" data-controller="librum-components-navbar">
            <div class="container is-max-widescreen">
              <div class="navbar-brand">
                <a class="navbar-item" href="/">
                  <span class="icon">
                    <i class="fa-solid fa-compass fa-2xl"></i>
                  </span>

                  <span class="title is-size-4">
                    Lodestone
                  </span>
                </a>

                <a role="button" class="navbar-burger" aria-label="menu" aria-expanded="false" data-action="click->librum-components-navbar#toggle" data-librum-components-navbar-target="button">
                  <span aria-hidden="true"></span>

                  <span aria-hidden="true"></span>

                  <span aria-hidden="true"></span>

                  <span aria-hidden="true"></span>
                </a>
              </div>

              <div id="primary-navigation" class="navbar-menu" data-librum-components-navbar-target="menu">
                <div class="navbar-start has-text-weight-semibold">
                  <a href="/board" class="navbar-item">
                    Board
                  </a>

                  <a href="/projects" class="navbar-item">
                    Projects
                  </a>

                  <a href="/tasks" class="navbar-item">
                    Tasks
                  </a>
                </div>
              </div>
            </div>
          </nav>

          <div class="container is-max-widescreen is-flex-grow-0 my-2">
            <div class="level">
              <div class="level-left">
                <div class="level-item">
                  <span>
                    You are currently logged in as

                    <a href="/authentication/user">
                      Alan Bradley
                    </a>

                    .
                  </span>
                </div>
              </div>

              <div class="level-right">
                <div class="level-item">
                  <form class="is-inline-block" action="/authentication/session" accept-charset="UTF-8" method="post">
                    <input type="hidden" name="_method" value="delete" autocomplete="off">

                    <button class="button has-text-danger is-outlined is-borderless is-shadowless m-0 p-0" type="submit">
                      <span class="icon">
                        <i class="fa-solid fa-user-xmark"></i>
                      </span>

                      <span>
                        Log Out
                      </span>
                    </button>
                  </form>
                </div>
              </div>
            </div>
          </div>

          <main class="section" style="flex: 1;">
            <div class="container content is-max-widescreen">
              <h1>
                Greetings, Starfighter!
              </h1>

              <p>
                You have been recruited by the Star League to defend the frontier
                against Xur and the Ko-Dan Armada!
              </p>
            </div>
          </main>

          <footer>
            <div class="footer">
              <div class="container is-max-widescreen">
                <p class="has-text-centered">
                  <span class="icon-text">
                    Sleeping&nbsp;King&nbsp;Studios is

                    <span class="icon">
                      <i class="fa-solid fa-copyright"></i>
                    </span>

                    Rob&nbsp;Smith 2021-2025
                  </span>
                </p>

                <p class="has-text-centered is-italic mt-1">
                  Non&nbsp;Sufficit&nbsp;Orbis
                </p>
              </div>
            </div>
          </footer>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end
  end
end
