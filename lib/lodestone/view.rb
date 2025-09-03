# frozen_string_literal: true

require 'librum/components/bulma'

module Lodestone
  # Namespace for view-specific configuration and components.
  module View
    CONFIGURATION = Librum::Components::Bulma::Configuration.new(
      **Librum::Components::Bulma::Configuration::DEFAULTS
    ).freeze
  end
end
