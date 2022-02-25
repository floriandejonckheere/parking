# frozen_string_literal: true

describe Parking::CLI do
  subject(:cli) { described_class.new(args) }

  # around { |example| suppress_output { example.run } }

  describe "options" do
    describe "--verbose" do
      let(:args) { ["--verbose"] }

      it "turns on verbose output" do
        cli

        expect(Parking.options).to be_verbose
      end
    end

    describe "--debug" do
      let(:args) { ["--debug"] }

      it "turns on debug output" do
        cli

        expect(Parking.options).to be_debug
      end
    end

    describe "--help" do
      let(:args) { ["--help"] }

      it "prints usage and exits" do
        expect { expect { cli }.to raise_error Parking::ExitError }.to log "[global options]"
      end
    end
  end
end
