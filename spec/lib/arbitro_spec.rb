require 'arbitro'

describe Arbitro do
  Result = Struct.new :id, :score
  Heat = Struct.new :results

  def get_me_an_array_of_results *scores
    scores.size.times.map { |id| Result.new id, scores[id] }
  end

  def get_me_an_array_of_arrays *scores
    scores.size.times.map { |id| [id, scores[id]] }
  end

  def get_me_a_hash *scores
    h = {}
    scores.each_with_index do |one_score, i|
      h[i] = one_score
    end
    h
  end

  [:get_me_an_array_of_results, :get_me_an_array_of_arrays, :get_me_a_hash].each do |heat_method|
    context ' - sum up some scores - ' do
      let(:heat1) { self.send heat_method, 2, 4, 7 }
      let(:heat2) { self.send heat_method, 3, 5, 6 }
      let(:heat3) { self.send heat_method, 4, 9, 4 }
      let(:heats) { [heat1, heat2, heat3] }

      context 'standard case - ' do
        subject { Arbitro.score heats }

        its(:sorted_ids) { should == [1,2,0] }
        its(:winner)     { should == 1 }
        its([0])         { should == 9 }
        its([1])         { should == 18 }
        its([2])         { should == 17 }
      end

      context 'lower wins - ' do
        subject { Arbitro.score heats, condition: :min}

        its(:sorted_ids) { should == [0,2,1] }
        its(:winner)     { should == 0 }
      end
    end
  end

  context ' - error handling - ' do
    it 'should raise when a bad type is passed in' do
      @param = 7
      @message_match = /that listens to :each(.*)#{7.class.name}/
    end

    it 'should raise when a heat array lacks something answering to score' do
      @param = [[7,1,2,3],[1,2,3,4]]
      @message_match = /something receiving :score or an array(.*)#{7.class.name}/
    end

    it 'should raise when a heat is not an array or a hash' do
      @param = [7,1,2,3]
      @message_match = /must be an Array or a Hash(.*)#{7.class.name}/
    end

    after :each do
      bad_scoring = lambda { Arbitro.score( @param ) }
      bad_scoring.should raise_exception( Arbitro::NotSupported ) { |e|  e.message.should =~ @message_match }
    end
  end

end
