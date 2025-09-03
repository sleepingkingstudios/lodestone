# frozen_string_literal: true

# Abstract base controller.
class ApplicationController < ActionController::Base
  class << self
    private

    def password
      ENV.fetch('BASIC_AUTH_PASSWORD') do
        Rails.application.credentials.authentication[:password]
      end
    end

    def username
      ENV.fetch('BASIC_AUTH_USERNAME') do
        Rails.application.credentials.authentication[:username]
      end
    end
  end

  http_basic_authenticate_with name: username, password: password

  layout 'legacy'
end
