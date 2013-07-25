
module Arbitro
  class NotSupported < Exception
  end

  class Results
    def initialize options = {}
      @options = options
      @results = Hash.new 0
    end

    def add_heat heat
      if heat.is_a? Array
        heat.each { |one_result| add_one_result_from_array one_result }
      elsif heat.is_a? Hash
        heat.each { |id, score| add_score id, score }
      else
        raise NotSupported, "A heat must be an Array or a Hash - found a #{heat.class.name}"
      end
    end

    def add_one_result_from_array one_result
      if one_result.respond_to? :score
        add_score one_result.id, one_result.score
      elsif one_result.is_a? Array
        add_score one_result[0], one_result[1]
      else
        raise NotSupported, "I expected something receiving :score or an array but got a #{one_result.class.name}"
      end
    end

    def add_score id, score
      @results[id] += score
    end

    def [] id
      @results[id]
    end

    def to_a
      lower_score_wins = @options[:condition] == :min
      @results.to_a.sort { |x,y| lower_score_wins ? x[1] <=> y[1] : y[1] <=> x[1] } 
    end

    def sorted_ids
      to_a.map { |result| result[0] }
    end

    def winner
      to_a.first[0]
    end
  end

  def self.score heats, options = {}
    unless heats.respond_to? :each
      raise NotSupported, "Only things that listens to :each allowed as first argument - you tried with a #{heats.class.name}"
    end
    results = Results.new options
    heats.each { |h| results.add_heat h }
    results
  end
end
