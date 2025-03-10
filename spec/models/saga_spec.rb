# frozen_string_literal: true

# == Schema Information
#
# Table name: sagas
#
#  id         :uuid             not null, primary key
#  name       :string           default(""), not null
#  slug       :string           default(""), not null
#  status     :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_sagas_on_name  (name) UNIQUE
#  index_sagas_on_slug  (slug) UNIQUE
#
require 'rails_helper'

RSpec.describe Saga, type: :model do
  pending 'To do'
end
