class PlatformsController < ApplicationController
  def index; end

  def create
    platform = Platform.find(params[:platforms])
    game = Game.find(params[:game_id])

    game.platforms << platform
    redirect_to game_path(game), notice: "Platform added correctly"
  end

  def destroy
    game = Game.find(params[:game])
    platforms = game.platforms.reject { |platform| platform.id.to_s == params[:platform] }
    game.platforms = platforms
    redirect_to root_path, notice: "Platform deleted correctly"
  end
end
