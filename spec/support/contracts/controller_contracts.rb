# frozen_string_literal: true

require 'rspec/sleeping_king_studios/contract'

require 'support/contracts'

module Spec::Support::Contracts
  module ControllerContracts
    module ShouldDefineAction
      extend RSpec::SleepingKingStudios::Contract

      contract do |action_name, action_class, member: false|
        describe "##{action_name}" do
          subject(:action) { described_class.actions[action_name.intern] }

          it { expect(described_class.actions).to have_key(action_name.intern) }

          it { expect(action.action_class).to be action_class }

          it { expect(action.member_action?).to be member }
        end
      end
    end

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
