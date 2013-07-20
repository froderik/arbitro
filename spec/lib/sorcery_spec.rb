require 'sorcery'

describe Sorcery do

  Result = Struct.new :id, :score
  Heat = Struct.new :results

  def get_me_a_heat *scores
    results = []
    scores.each_with_index do |one_score, i|
      results << Result.new( i, one_score )
    end

    Heat.new results
  end

  context ' - some up some scores - maximum wins - ' do
    let(:heat1) { get_me_a_heat 2, 4, 7 }
    let(:heat2) { get_me_a_heat 3, 5, 6 }
    let(:heat3) { get_me_a_heat 4, 9, 4 }

    subject { totals = Sorcery.score [heat1, heat2, heat3] }

    its(:results) {should == [1,2,0]}
    it { subject[0].should == 9 }
    it { subject[1].should == 18 }
    it { subject[2].should == 17 }
  end

end
