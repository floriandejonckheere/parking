# frozen_string_literal: true

module Parking
  module Algorithms
    class Genetic < Random
      attr_reader :population

      def initialize(...)
        super

        # Generate initial population
        @population = 5.times.map { Individual.new(mutate(actions.map(&:first))) }
      end

      def run
        action = action_iterator.next

        car.drive(**action)
      rescue StopIteration
        # Compute fitness
        individual.fitness = car.score(target)

        Parking.logger.debug "Score for individual #{individual}"

        # Start selection phase only if fitness was computed for all individuals
        return rereset unless population.all?(&:fitness)

        # Selection of fittest individuals
        father, mother = population.sort_by(&:fitness).last(2)

        # Crossover and mutate
        child = father.crossover(mother)
        Parking.logger.debug "#{father} + #{mother} = #{child}"

        # Check convergence
        if child.genes == father.genes || child.genes == mother.genes
          Parking.logger.info "Best score: #{father.fitness.truncate(2)} with input #{child.genes}"

          exit
        end

        # Add offspring to population
        population << child
        Parking.logger.debug "Population: #{population}"

        # Reset simulation
        rereset
      end

      def self.description
        "Genetic algorithm"
      end

      private

      def rereset
        @individual = population_iterator.next
        @action_iterator = nil

        reset.call
      end

      def population_iterator
        @population_iterator ||= population.each
      end

      def individual
        @individual ||= population_iterator.next
      end

      def action_iterator
        @action_iterator ||= Iterator.new(individual.genes.zip(actions.map(&:last)))
      end
    end
  end
end
