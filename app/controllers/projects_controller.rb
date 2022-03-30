# frozen_string_literal: true

# Controller for managing Project entities.
class ProjectsController < BaseController
  def self.resource # rubocop:disable Metrics/MethodLength
    Cuprum::Rails::Resource.new(
      default_order:        :name,
      permitted_attributes: %w[
        active
        description
        name
        project_type
        public
        repository
        slug
      ],
      resource_class:       ::Project
    )
  end

  action :create,  Actions::Projects::Create
  action :destroy, Cuprum::Rails::Actions::Destroy, member: true
  action :edit,    Cuprum::Rails::Actions::Edit,    member: true
  action :index,   Cuprum::Rails::Actions::Index
  action :new,     Cuprum::Rails::Actions::New
  action :show,    Cuprum::Rails::Actions::Show,    member: true
  action :update,  Cuprum::Rails::Actions::Update,  member: true
end
