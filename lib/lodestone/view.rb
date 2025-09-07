# frozen_string_literal: true

module Lodestone
  # Namespace for view-specific configuration and components.
  module View
    defaults = Librum::Components::Bulma::Configuration::DEFAULTS

    CONFIGURATION = Librum::Components::Bulma::Configuration.new(
      **defaults,
      colors: [*defaults['colors'], 'slate'].freeze
    ).freeze
  end
end
