# frozen_string_literal: true

module Lodestone::Boards::View
  # Component displaying a column of board results.
  class Show::Column < Librum::Components::Bulma::Base
    dependency :routes

    option :status
    option :tasks

    private

    def render_task(task)
      component = Lodestone::Boards::View::Components::Task.new(task:)

      render(component)
    end
  end
end
