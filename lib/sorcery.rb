
module Sorcery
  class Results
    def initialize options = {}
      @options = options
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
      if @options[:condition] == :min
        @results.to_a.sort {|x,y| x[1] <=> y[1]} 
      else
        @results.to_a.sort {|x,y| y[1] <=> x[1]} 
      end
    end

    def sorted_ids
      to_a.map { |result| result[0] }
    end

    def winner
      to_a.first[0]
    end
  end

  def self.score heats, options = {}
    results = Results.new options
    heats.each { |h| results.add_heat h }
    results
  end
end
