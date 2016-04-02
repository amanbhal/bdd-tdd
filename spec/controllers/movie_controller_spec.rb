require 'spec_helper'

describe MoviesController do

  describe 'add director' do
    before :each do
      @m=mock(Movie, :title => "Star Wars", :director => "George Lucas", :id => "1")
      Movie.stub!(:find).with("1").and_return(@m)
    end
    it 'should call update_attributes and redirect' do
      @m.stub!(:update_attributes!).and_return(true)
      put :update, {:id => "1", :movie => @m}
      response.should redirect_to(movie_path(@m))
    end 
  end 

  describe "happy path" do
    before :each do
      @m = mock(Movie, :title=>"Star Wars", :director =>"George Lucas", :id =>"1")
      Movie.stub!(:find).with("1").and_return(@m)
      #@m2 = mock(Movie, :title=>"THX-1138", :director => "George Lucas", :id => "2")
      #@m3 = mock(Movie, :title=> "Blade Runner", :director => "Ridley Scott", :id => "3")
      
      #Movie.stub!(:find).with("2").and_return(@m2)
      #Movie.stub!(:find).with("3").and_return(@m3)
    end
    it 'should generate routing for Similar Movies' do
      { :post => same_director_path(1) }.
      should route_to(:controller => "movies", :action => "same_director", :id => "1")
    end
    it 'should call the model method that finds similar movies' do      
      expect(Movie).to receive(:same_director).with("George Lucas")
      get :same_director, {:id => "1"}
    end
    it 'should select the Similar template for rendering and make results available' do
      Movie.stub!(:same_director).with('George Lucas').and_return(@m)
      get :same_director, :id => "1"
      response.should render_template('same_director')
      assigns(:movies).should == @m
    end
  end

  describe 'sad path' do
    before :each do
      m=mock(Movie, :title => "Star Wars", :director => nil, :id => "1")
      Movie.stub!(:find).with("1").and_return(m)
    end
    
    it 'should generate routing for Similar Movies' do
      { :post => same_director_path(1) }.
      should route_to(:controller => "movies", :action => "same_director", :id => "1")
    end
    it 'should select the Index template for rendering and generate a flash' do
      get :same_director, :id => "1"
      response.should redirect_to(movies_path)
      flash[:notice].should_not be_blank
    end
  end

   describe 'create and destroy' do
    it 'should create a new movie' do
      MoviesController.stub(:create).and_return(mock('Movie'))
      post :create, {:id => "1"}
    end
    it 'should destroy a movie' do
      m = mock(Movie, :id => "10", :title => "blah", :director => nil)
      Movie.stub!(:find).with("10").and_return(m)
      m.should_receive(:destroy)
      delete :destroy, {:id => "10"}
    end
  end

end

