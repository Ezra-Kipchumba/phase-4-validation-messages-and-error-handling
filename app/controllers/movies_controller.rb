class MoviesController < ApplicationController
 rescue_from ActiveRecord::RecordNotFound, with: :movie_not_found
  
  wrap_parameters false
  
  def index
    movies = Movie.all
    render json: movies, except: [:created_at, :updated_at]
  end

  def create
  movie = Movie.create!(movie_params)
  render json: movie, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def destroy
    movie = find_movie
    movie.destroy
    head :no_content
  end

  private

  def movie_params
    params.permit(:title, :year, :length, :director, :description, :poster_url, :category, :discount, :female_director)
  end

  def find_movie
    Movie.find_by(id: params[:id])
  end

  def movie_not_found
    render json: {error: "movie not found"},status: :not_found
  end
  
end
