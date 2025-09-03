# frozen_string_literal: true

Rails.application.config.after_initialize do
  components    = Lodestone::View::Components
  configuration = Lodestone::View::CONFIGURATION
  routes        = Class.new.include(Rails.application.routes.url_helpers).new

  Librum::Components::Provider.set('components',    components)
  Librum::Components::Provider.set('configuration', configuration)
  Librum::Components::Provider.set('routes',        routes)
end
