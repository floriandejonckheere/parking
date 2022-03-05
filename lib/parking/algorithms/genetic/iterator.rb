# frozen_string_literal: true

module Parking
  module Algorithms
    class Genetic
      class Iterator
        attr_reader :population

        def initialize(population)
          @population = population
        end

        def next
          return next! if individual.fitness

          [individual, action_iterator.next]
        rescue StopIteration
          next!
        end

        def next!
          previous_individual = individual
          @individual = population_iterator.next
          @action_iterator = nil

          previous_individual
        rescue StopIteration
          nil
        end

        def population_iterator
          @population_iterator ||= population.each
        end

        def individual
          @individual ||= population_iterator.next
        end

        def action_iterator
          @action_iterator ||= Parking::Algorithms::Iterator.new(individual.genes.zip(actions.map(&:last)))
        end

        def actions
          Simple::ACTIONS[Parking.options.layout.to_sym]
        end
      end
    end
  end
end
