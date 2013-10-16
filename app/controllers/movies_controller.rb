class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    if params[:sort_param].nil? && params[:ratings].nil? && (!session[:sort_param].nil? || !session[:ratings].nil?)
      redirect_to movies_path(:sort_param => session[:sort_param], :ratings => session[:ratings])
    end

    @all_ratings = Movie.all_ratings
    @sort = params[:sort_param]
    @ratings = params[:ratings]

    if @ratings.nil?
      @ratings = Hash[@all_ratings.map {|rating| [rating, 1]}]
    else
      ratings = @ratings.keys
    end

    if !@sort.nil? and !@ratings.nil?
      @movies = Movie.where(:rating => @ratings.keys).find(:all, :order => @sort)
    elsif !@sort.nil?
      @movies = Movie.find(:all, :order => @sort)
    elsif !@ratings.nil?
      @movies = Movie.where(:rating => @ratings.keys)
    else
      @movies = Movie.all
    end

    session[:sort_param] = @sort
    session[:ratings] = @ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
