# frozen_string_literal: true

module Lodestone::Tasks::Commands
  # Finds and updates an entity by ID or slug with optional generated slug.
  class Update < Librum::Core::Commands::Resources::Update
    ATTRIBUTE_NAMES_FOR_SLUG = %i[title].freeze
    private_constant :ATTRIBUTE_NAMES_FOR_SLUG

    private

    def attribute_names_for_slug
      ATTRIBUTE_NAMES_FOR_SLUG
    end
  end
end
