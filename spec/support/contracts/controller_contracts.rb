# frozen_string_literal: true

require 'rspec/sleeping_king_studios/contract'

require 'support/contracts'

module Spec::Support::Contracts
  module ControllerContracts
    module ShouldNotRespondToContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |format|
        it { expect(described_class.responders[format]).to be nil }
      end
    end

    module ShouldRespondToContract
      extend RSpec::SleepingKingStudios::Contract

      contract do |format, using:|
        it { expect(described_class.responders[format]).to be == using }
      end
    end
  end
end
