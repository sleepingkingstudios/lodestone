# frozen_string_literal: true

module Lodestone::Tasks::Commands
  # Builds a Task with generated uuid ID and slug.
  class New < Librum::Core::Commands::Resources::New
    ATTRIBUTE_NAMES_FOR_SLUG = %i[title].freeze
    private_constant :ATTRIBUTE_NAMES_FOR_SLUG

    private

    def attribute_names_for_slug
      ATTRIBUTE_NAMES_FOR_SLUG
    end
  end
end
