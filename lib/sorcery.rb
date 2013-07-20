
module Sorcery
  class Results
    def add_heat heat
      @heats ||= []
      @heats << heat.results

      @results ||= Hash.new 0
      heat.results.each do |one_result|
        @results[one_result.id] += one_result.score
      end
    end

    def [] id
      @results[id]
    end

    def results
      @results.to_a.sort {|x,y| y[1] <=> x[1]} .map { |result| result[0] }
    end
  end

  def self.score heats
    results = Results.new
    heats.each { |h| results.add_heat h }
    results
  end
end
