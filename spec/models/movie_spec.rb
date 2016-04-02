require 'spec_helper'

describe Movie do
  before :each do
      @m=mock(Movie, :title => "Star Wars", :director => "George Lucas", :id => "1")
      Movie.stub!(:find).with("1").and_return(@m)
  end
  describe 'searching similar directors' do
    it 'should call Movie with director' do
      Movie.should_receive(:same_director).with('George Lucas')
      Movie.same_director("George Lucas")
    end
  end
end