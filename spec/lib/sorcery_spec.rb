require 'sorcery'

describe Sorcery do

  Result = Struct.new :id, :score
  Heat = Struct.new :results

  def get_me_a_heat *scores
    results = []
    scores.each_with_index do |one_score, i|
      results << Result.new( i, one_score )
    end

    results
  end

  def get_me_an_array *scores
    results = []
    scores.each_with_index {|one_score, i| results << [i, one_score] }
    results
  end

  [:get_me_a_heat, :get_me_an_array].each do |heat_method|
    context ' - sum up some scores - ' do
      let(:heat1) { self.send heat_method, 2, 4, 7 }
      let(:heat2) { self.send heat_method, 3, 5, 6 }
      let(:heat3) { self.send heat_method, 4, 9, 4 }
      let(:heats) { [heat1, heat2, heat3] }

      context 'standard case - ' do
        subject { Sorcery.score heats }

        its(:sorted_ids) { should == [1,2,0] }
        its(:winner)     { should == 1 }
        its([0])         { should == 9 }
        its([1])         { should == 18 }
        its([2])         { should == 17 }
      end

      context 'lower wins - ' do
        subject { Sorcery.score heats, condition: :min}

        its(:sorted_ids) { should == [0,2,1] }
        its(:winner)     { should == 0 }
      end
    end
  end

end
