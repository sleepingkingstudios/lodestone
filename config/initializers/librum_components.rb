# frozen_string_literal: true

Rails.application.config.after_initialize do
  components    = -> { Lodestone::View::Components }
  configuration = -> { Lodestone::View::CONFIGURATION }
  routes        = Class.new.include(Rails.application.routes.url_helpers).new

  Librum::Components.provider.set(:components,    components)
  Librum::Components.provider.set(:configuration, configuration)
  Librum::Components.provider.set(:routes,        routes)
end
