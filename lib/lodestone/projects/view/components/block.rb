# frozen_string_literal: true

module Lodestone::Projects::View::Components
  # Renders the block for a Projects show view.
  class Block < Librum::Components::Views::Resources::Elements::Block
    FIELDS = [
      { key: 'name' },
      { key: 'active', type: :boolean },
      { key: 'public', type: :boolean },
      { key: 'project_type', transform: :titleize },
      { key: 'repository' }
    ].freeze
    private_constant :FIELDS
  end
end
