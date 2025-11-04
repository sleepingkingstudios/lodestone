# frozen_string_literal: true

# Controller for managing task boards.
class BoardsController < ViewController
  def self.resource
    @resource ||= Librum::Core::Resource.new(
      name:                'board',
      singular:            true,
      skip_authentication: true
    )
  end

  action :show,
    Cuprum::Rails::Action,
    command_class: Lodestone::Boards::Commands::Show,
    member:        false
end
