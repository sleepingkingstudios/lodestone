# frozen_string_literal: true

require 'cuprum/rails/actions/create'

module Actions::Projects
  # Create action for the Project API.
  class Create < Cuprum::Rails::Actions::Create
    prepend Actions::GenerateSlug
  end
end
