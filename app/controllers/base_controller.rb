# frozen_string_literal: true

require 'cuprum/rails/controller'
require 'cuprum/rails/repository'
require 'cuprum/rails/responders/html/resource'

# Abstract base controller using Cuprum::Rails functionality.
class BaseController < ApplicationController
  include Cuprum::Rails::Controller

  def self.repository
    @repository ||= Cuprum::Rails::Records::Repository.new
  end

  default_format :html

  responder :html, Cuprum::Rails::Responders::Html::Resource
end
