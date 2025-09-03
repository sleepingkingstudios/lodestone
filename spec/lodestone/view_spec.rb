# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::View do
  describe '::CONFIGURATION' do
    let(:expected_options) do
      Librum::Components::Bulma::Configuration::DEFAULTS
    end
    let(:configuration) do
      described_class::CONFIGURATION
    end

    include_examples 'should define constant',
      :CONFIGURATION,
      -> { be_a Librum::Components::Configuration }

    it { expect(configuration.options).to be == expected_options }
  end
end
