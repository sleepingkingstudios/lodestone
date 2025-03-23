# frozen_string_literal: true

# Controller for managing task boards.
class BoardsController < Librum::Core::ViewController
  def self.resource
    @resource ||=
      Librum::Core::Resources::BaseResource.new(name: 'board', singular: true)
  end

  layout 'application'

  responder :html, Cuprum::Rails::Responders::Html::Resource

  action :show,
    Cuprum::Rails::Action.subclass(
      command_class: Lodestone::Boards::Commands::Show
    ),
    member: false
end
