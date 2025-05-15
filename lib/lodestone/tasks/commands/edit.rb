# frozen_string_literal: true

module Lodestone::Tasks::Commands
  # Finds and edits a Task by ID or slug with optional generated slug.
  class Edit < Librum::Core::Commands::Resources::Edit
    ATTRIBUTE_NAMES_FOR_SLUG = %i[title].freeze
    private_constant :ATTRIBUTE_NAMES_FOR_SLUG

    private

    def attribute_names_for_slug
      ATTRIBUTE_NAMES_FOR_SLUG
    end
  end
end
