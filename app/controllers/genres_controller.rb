class GenresController < ApplicationController
  def index; end

  def create
    genre = Genre.find(params[:genres])
    game = Game.find(params[:game_id])

    game.genres << genre
    redirect_to game_path(game), notice: "Genre added correctly"
  end

  def destroy
    game = Game.find(params[:game])
    genres = game.genres.reject { |genre| genre.id.to_s == params[:genre] }
    game.genres = genres
    redirect_to root_path, notice: "Genre deleted correctly"
  end
end
