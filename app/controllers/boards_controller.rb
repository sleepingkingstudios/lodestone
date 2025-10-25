# frozen_string_literal: true

# Controller for managing task boards.
class BoardsController < BaseController
  def self.resource
    @resource ||=
      Librum::Core::Resources::BaseResource.new(name: 'board', singular: true)
  end

  action :show,
    Cuprum::Rails::Action,
    command_class: Lodestone::Boards::Commands::Show,
    member:        false
end
