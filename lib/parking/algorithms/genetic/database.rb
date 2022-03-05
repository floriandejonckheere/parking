# frozen_string_literal: true

module Parking
  module Algorithms
    class Genetic
      class Database
        def self.read(genes)
          database[genes.join("-")]
        end

        def self.write(genes, fitness)
          database[genes.join("-")] = fitness

          File.write(Parking.root.join("lib/parking/algorithms/genetic/fitness.yml"), database.to_yaml)

          fitness
        end

        def self.database
          @database ||= begin
            YAML.load_file(Parking.root.join("lib/parking/algorithms/genetic/fitness.yml"))
          rescue Errno::ENOENT
            {}
          end
        end
      end
    end
  end
end
