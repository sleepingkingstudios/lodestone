# frozen_string_literal: true

require 'rails_helper'

require 'support/contracts/controller_contracts'

RSpec.describe BaseController, type: :controller do
  include Spec::Support::Contracts::ControllerContracts

  describe '.default_format' do
    it { expect(described_class.default_format).to be :html }
  end

  describe '.repository' do
    subject(:repository) { described_class.repository }

    it { expect(repository).to be_a Cuprum::Rails::Records::Repository }
  end

  describe '.responders' do
    include_contract 'should respond to',
      :html,
      using: Librum::Core::Responders::Html::ViewResponder

    include_contract 'should not respond to', :json
  end
end
