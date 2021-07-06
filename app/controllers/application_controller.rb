# frozen_string_literal: true

class ApplicationController < ActionController::Base
  http_basic_authenticate_with \
    name:     Rails.application.credentials.authentication[:username],
    password: Rails.application.credentials.authentication[:password]
end
