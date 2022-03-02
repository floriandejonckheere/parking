# frozen_string_literal: true

RSpec.describe Parking::Options do
  subject(:options) { described_class.new }

  it { is_expected.to respond_to :model, :model= }
  it { is_expected.to respond_to :debug, :debug?, :debug= }

  describe "#[]" do
    it "gets the option value" do
      options.model = "fiat"

      expect(options[:model]).to eq "fiat"
    end
  end

  describe "#[]=" do
    it "sets the option value" do
      options[:model] = "fiat"

      expect(options.model).to eq "fiat"
    end
  end
end
