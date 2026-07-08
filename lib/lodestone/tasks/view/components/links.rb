# frozen_string_literal: true

require 'lodestone/tasks/view/components'

module Lodestone::Tasks::View::Components
  # Renders supplemental links for a Task view.
  class Links < Librum::Components::Bulma::Base
    option :task

    private

    def build_board_link
      components::Link.new(
        color: 'link',
        icon:  'rectangle-list',
        text:  'Project Board',
        url:   "/projects/#{task.project['slug']}/board"
      )
    end

    def build_status_button(status:, text:, icon: nil)
      Lodestone::Tasks::View::Components::StatusButton.new(
        icon:,
        status:,
        task:,
        text:
      )
    end

    def grid_class_names
      bulma_class_names(
        'fixed-grid has-1-cols has-4-cols-tablet has-6-cols-desktop'
      )
    end

    def links
      links = []

      links << build_board_link

      status_transitions.each.with_index do |(status, text), index|
        icon = index.zero? ? 'arrow-left' : 'arrow-right'

        next if status.nil?

        links << build_status_button(icon:, status:, text:)
      end

      links
    end

    def status_transitions
      return [] unless task

      Lodestone::Tasks::View::Components::TASK_STATUS_TRANSITIONS
        .fetch(task.status)
    end
  end
end
