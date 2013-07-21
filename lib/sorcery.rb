
module Sorcery
  class Results
    def initialize 
      @heats = []
      @results = Hash.new 0
    end

    def add_heat heat
      @heats << heat.results

      heat.results.each do |one_result|
        @results[one_result.id] += one_result.score
      end
    end

    def [] id
      @results[id]
    end

    def to_a
      @results.to_a.sort {|x,y| y[1] <=> x[1]} 
    end

    def sorted_ids
      to_a.map { |result| result[0] }
    end
  end

  def self.score heats
    results = Results.new
    heats.each { |h| results.add_heat h }
    results
  end
end
