# frozen_string_literal: true

module Lodestone::Tasks::View
  # Namespace and helpers for defining Task view components.
  module Components
    STATUS_COLOR_NAMES = {
      ::Task::Statuses::DONE        => 'slate',
      ::Task::Statuses::ICEBOX      => 'info',
      ::Task::Statuses::IN_PROGRESS => 'success',
      ::Task::Statuses::TO_DO       => 'link'
    }.freeze
    private_constant :STATUS_COLOR_NAMES

    TASK_STATUS_TRANSITIONS = {
      ::Task::Statuses::WONT_DO     => {
        nil                      => nil,
        ::Task::Statuses::ICEBOX => 'restore'
      }.freeze,
      ::Task::Statuses::ICEBOX      => {
        ::Task::Statuses::WONT_DO => 'cancel',
        ::Task::Statuses::TO_DO   => 'prioritize'
      }.freeze,
      ::Task::Statuses::TO_DO       => {
        ::Task::Statuses::ICEBOX      => 'freeze',
        ::Task::Statuses::IN_PROGRESS => 'start'
      }.freeze,
      ::Task::Statuses::IN_PROGRESS => {
        ::Task::Statuses::TO_DO => 'stop',
        ::Task::Statuses::DONE  => 'finish'
      }.freeze,
      ::Task::Statuses::DONE        => {
        ::Task::Statuses::IN_PROGRESS => 'restart',
        ::Task::Statuses::ARCHIVED    => 'archive'
      }.freeze,
      ::Task::Statuses::ARCHIVED    => {
        ::Task::Statuses::DONE => 'unarchive'
      }.freeze
    }.freeze

    TASK_TYPE_ICON_NAMES = {
      ::Task::TaskTypes::BUGFIX        => 'bug',
      ::Task::TaskTypes::CHORE         => 'wrench',
      ::Task::TaskTypes::EPIC          => 'lightbulb',
      ::Task::TaskTypes::FEATURE       => 'gear',
      ::Task::TaskTypes::INVESTIGATION => 'search',
      ::Task::TaskTypes::MILESTONE     => 'trophy',
      ::Task::TaskTypes::RELEASE       => 'award'
    }.freeze
    private_constant :TASK_TYPE_ICON_NAMES

    class << self
      # Formats a Task status for display.
      #
      # @param status [String] the status to format.
      #
      # @return [String, nil] the formatted status.
      def format_status(status)
        case status
        when Task::Statuses::WONT_DO
          "Won't Do"
        else
          status&.titleize
        end
      end

      # Finds the color name for the given task status.
      #
      # @param status [String] the task status.
      #
      # @return [String] the color name.
      def status_color(status)
        STATUS_COLOR_NAMES.fetch(status.to_s, 'text')
      end

      # Finds the icon name for the given task type.
      #
      # @param type [String] the task type.
      #
      # @return [String] the icon name.
      def task_type_icon(type)
        TASK_TYPE_ICON_NAMES.fetch(type.to_s, 'exclamation-triangle')
      end
    end
  end
end
