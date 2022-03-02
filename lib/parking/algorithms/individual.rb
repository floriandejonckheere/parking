# frozen_string_literal: true

module Parking
  module Algorithms
    class Individual
      attr_reader :genes
      attr_accessor :fitness

      def initialize(genes, fitness = nil)
        @genes = genes
        @fitness = fitness
      end

      def crossover(other)
        # Instead of using a crossover point, randomize gene selection from parent
        offspring = genes
          .zip(other.genes)
          .map(&:sample)

        self.class.new(offspring)
      end

      def inspect
        "[#{genes.join(', ')}] => #{fitness&.truncate(2)}"
      end
      alias to_s inspect
    end
  end
end
