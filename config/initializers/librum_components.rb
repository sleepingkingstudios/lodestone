# frozen_string_literal: true

components    = -> { Lodestone::View::Components }
configuration = -> { Lodestone::View::CONFIGURATION }
values        =
  Librum::Components::PROVIDER_KEYS
  .index_with { |_| Plumbum::UNDEFINED }
  .merge(components:, configuration:)
options =
  if Rails.application.config.enable_reloading
    { read_only: false }
  else
    { write_once: true }
  end
provider =
  Plumbum::ManyProvider
  .new(values:, **options)
  .extend(Plumbum::Providers::Lazy)

Librum::Components.provider = provider

Rails.application.config.after_routes_loaded do
  provider.set :routes,
    Class.new.include(Rails.application.routes.url_helpers).new
end
