# frozen_string_literal: true

# A task management application built on Librum and Rails.
module Lodestone
  class << self
    CONTROLLER_PATTERN = /Controller\z/
    private_constant :CONTROLLER_PATTERN

    WHITESPACE_PATTERN = /\s+/
    private_constant :WHITESPACE_PATTERN

    # Finds the view path for the specified action and controller.
    #
    # @param action [String] the name of the action.
    # @param controller [String] the name of the controller.
    #
    # @return [String] the formatted view path.
    def view_path(action:, controller:, **)
      controller = controller.sub(CONTROLLER_PATTERN, '')

      convert_to_class_name("Lodestone::#{controller}::View::#{action}")
    end

    private

    def convert_to_class_name(value)
      value
        .to_s
        .titleize
        .gsub('/', '::')
        .gsub(WHITESPACE_PATTERN, '')
    end
  end
end
