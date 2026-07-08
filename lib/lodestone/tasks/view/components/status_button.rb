# frozen_string_literal: true

module Lodestone::Tasks::View::Components
  # Button for updating a Task status.
  class StatusButton < Librum::Components::Bulma::Base
    option :icon
    option :status
    option :task
    option :text

    private

    def build_button
      components::Button.new(
        class_name: button_class_name,
        icon:,
        text:       "#{tools.string_tools.camelize(text)} Task",
        type:       'submit'
      )
    end

    def button_class_name
      class_names(
        bulma_class_names('px-2 py-0'),
        'is-borderless',
        'is-shadowless'
      )
    end

    def url
      "/tasks/#{task.slug}/status"
    end
  end
end
