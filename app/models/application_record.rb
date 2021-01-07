# frozen_string_literal: true

# Abstract base class for Lodestone models.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
