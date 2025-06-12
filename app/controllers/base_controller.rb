# frozen_string_literal: true

require 'cuprum/rails/controller'
require 'cuprum/rails/repository'
require 'cuprum/rails/responders/html/resource'

# Abstract base controller using Cuprum::Rails functionality.
class BaseController < ApplicationController
  include Cuprum::Rails::Controller

  def self.repository
    @repository ||= Cuprum::Rails::Records::Repository.new.tap do |repository|
      repository.create(entity_class: Project)
      repository.create(entity_class: Task)
      repository.create(entity_class: TaskRelationship)
    end
  end

  default_format :html

  unless Rails.env.production?
    middleware Cuprum::Rails::Actions::Middleware::LogRequest
    middleware Cuprum::Rails::Actions::Middleware::LogResult
  end

  responder :html, Cuprum::Rails::Responders::Html::Resource
end
