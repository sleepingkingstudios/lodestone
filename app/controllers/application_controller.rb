# frozen_string_literal: true

require 'cuprum/rails/controller'
require 'cuprum/rails/repository'

# Abstract base controller.
class ApplicationController < ActionController::Base
  include Cuprum::Rails::Controller

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

  def self.repository
    @repository ||= Cuprum::Rails::Records::Repository.new.tap do |repository|
      repository.create(entity_class: Project)
      repository.create(entity_class: Task)
      repository.create(entity_class: TaskRelationship)
    end
  end

  http_basic_authenticate_with name: username, password: password

  unless Rails.env.production?
    middleware Cuprum::Rails::Actions::Middleware::LogRequest
    middleware Cuprum::Rails::Actions::Middleware::LogResult
  end
end
