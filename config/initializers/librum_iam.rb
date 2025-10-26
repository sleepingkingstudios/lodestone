# frozen_string_literal: true

Rails.application.config.before_initialize do |app|
  app.config.authentication_session_path = '/authentication/session'
end
