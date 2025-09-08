# frozen_string_literal: true

require 'lodestone'

RSpec.describe Lodestone do
  describe '.view_path' do
    let(:action)     { 'publish' }
    let(:controller) { 'books' }
    let(:expected)   { 'Lodestone::Books::View::Publish' }
    let(:view_path)  { described_class.view_path(action:, controller:) }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:view_path)
        .with(0).arguments
        .and_keywords(:action, :controller)
    end

    it { expect(view_path).to be == expected }

    describe 'with a complex controller name' do
      let(:controller) { 'books/by_author/unpublished' }
      let(:expected) do
        'Lodestone::Books::ByAuthor::Unpublished::View::Publish'
      end

      it { expect(view_path).to be == expected }
    end
  end
end
