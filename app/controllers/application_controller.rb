# frozen_string_literal: true

require 'cuprum/rails/controller'
require 'cuprum/rails/repository'

# Abstract base controller.
class ApplicationController < ActionController::Base
  include Cuprum::Rails::Controller

  def self.repository
    @repository ||= Cuprum::Rails::Records::Repository.new.tap do |repository|
      repository.create(entity_class: Project)
      repository.create(entity_class: Task)
      repository.create(entity_class: TaskRelationship)
    end
  end

  unless Rails.env.production?
    middleware Cuprum::Rails::Actions::Middleware::LogRequest
    middleware Cuprum::Rails::Actions::Middleware::LogResult
  end
end
