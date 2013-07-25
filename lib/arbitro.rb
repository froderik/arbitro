
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
        heat.each do |one_result|
          if one_result.respond_to? :score
            @results[one_result.id] += one_result.score
          elsif one_result.is_a? Array
            @results[one_result[0]] += one_result[1]
          else
            raise NotSupported, "I expected something receiving :score or an array but got a #{one_result.class.name}"
          end
        end
      elsif heat.is_a? Hash
        heat.each do |id, score|
          @results[id] += score
        end
      else
        raise NotSupported, "A heat must be an Array or a Hash - found a #{heat.class.name}"
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
    raise( NotSupported, each_not_supported( heats ) ) unless heats.respond_to? :each
    results = Results.new options
    heats.each { |h| results.add_heat h }
    results
  end

  private

  def self.each_not_supported heats
    "Only things that listens to :each allowed as first argument - you tried with a #{heats.class.name}"
  end
end
