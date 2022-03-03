# frozen_string_literal: true

module Parking
  module Algorithms
    class Genetic
      class Database
        def self.read(genes)
          Parking.logger.debug "Reading #{genes.join('-')}: #{database[genes.join('-')]}"
          database[genes.join("-")]
        end

        def self.write(genes, fitness)
          Parking.logger.debug "Writing #{genes.join('-')}: #{fitness}"
          database[genes.join("-")] = fitness

          File.write(Parking.root.join("lib/parking/algorithms/genetic/fitness.yml"), database.to_yaml)

          fitness
        end

        def self.database
          @database ||= YAML.load_file(Parking.root.join("lib/parking/algorithms/genetic/fitness.yml"))
        end
      end
    end
  end
end
