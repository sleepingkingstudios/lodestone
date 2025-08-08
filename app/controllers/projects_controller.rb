# frozen_string_literal: true

require 'librum/core/commands/resources/new'

# Controller for managing Project entities.
class ProjectsController < BaseController
  def self.resource # rubocop:disable Metrics/MethodLength
    Cuprum::Rails::Resource.new(
      default_order:        :name,
      entity_class:         ::Project,
      permitted_attributes: %w[
        active
        description
        name
        project_type
        public
        repository
        slug
      ]
    )
  end

  action :create,
    Cuprum::Rails::Actions::Resources::Create,
    command_class: Librum::Core::Commands::Resources::Create
  action :destroy,
    Cuprum::Rails::Actions::Resources::Destroy,
    command_class: Librum::Core::Commands::Resources::Destroy,
    member:        true
  action :edit,
    Cuprum::Rails::Actions::Resources::Edit,
    command_class: Librum::Core::Commands::Resources::Edit,
    member:        true
  action :index,
    Cuprum::Rails::Actions::Resources::Index
  action :new,
    Cuprum::Rails::Actions::Resources::New,
    command_class: Librum::Core::Commands::Resources::New
  action :show,
    Cuprum::Rails::Actions::Resources::Show,
    command_class: Librum::Core::Commands::Resources::Show,
    member:        true
  action :update,
    Cuprum::Rails::Actions::Resources::Update,
    command_class: Librum::Core::Commands::Resources::Update,
    member:        true
end
