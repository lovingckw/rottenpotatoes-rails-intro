class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:order_by]=="movie"
      session[:order_by] = "movie"
    elsif params[:order_by]=="release_date"
      session[:order_by] = "release_date"
    end

    if session[:order_by]=="movie"
      @chosen_ratings = session[:ratings].keys
      @movies = []
      Movie.all.each do |movie|
        if @chosen_ratings.include?movie[:rating]
          @movies.push movie
        end
      end
      @movies.sort_by!{|p| p[:title]}
      @highlighted="movie"
    elsif session[:order_by]=="release_date"
      @chosen_ratings = session[:ratings].keys
      @movies = []
      Movie.all.each do |movie|
        if @chosen_ratings.include?movie[:rating]
          @movies.push movie
        end
      end
      @movies.sort_by!{|p| p[:release_date]}
      @highlighted="date"
    else
      @movies = Movie.all
    end

    params[:order_by] = session[:order_by]

    self.all_ratings

    session[:ratings] = params[:ratings] if !params[:ratings].nil?
    if params[:ratings]
      # @chosen_ratings = session[:ratings].keys
      @chosen_ratings = params[:ratings].keys
      @movies = []
      Movie.all.each do |movie|
        if @chosen_ratings.include?movie[:rating]
          @movies.push movie
        end
      end
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def all_ratings
    @all_ratings = []
    movies = Movie.all
    movies.each do |movie|
      @all_ratings.push movie[:rating]
    end
    @all_ratings.uniq!
  end
end
