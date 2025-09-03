# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::View::Components do
  it { expect(described_class).to be < Librum::Components::Bulma }
end
