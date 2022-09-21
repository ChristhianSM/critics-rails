class GamesController < ApplicationController
  # Esto lo que haces es buscar la funcion set_game y busca el id del departamento, es para no repetir esa linea de codigo que siempre la tenemos que usar.
  before_action :set_game, only: %i[show edit update destroy]

  # GET /games
  def index
    @games = Game.all
  end

  # GET /games/1
  def show; end

  # GET /games/new
  def new
    @game = Game.new
    @show_image = false
  end

  # GET /games/:id/edit
  def edit
    @show_image = true
  end

 

  # POST /games
  def create
    @game = Game.new(game_params)
    unless @game.cover.attached?
      @game.cover.attach(io: File.open("app/assets/images/random.webp"), filename: "game_cover")
    end

    if @game.save
      # @game  -> ira a listado de departamentos
      redirect_to root_path, notice: "game was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /games/:id
  def update
    if @game.update(game_params)
      redirect_to root_path, notice: "game was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /games/:id
  def destroy
    @game.destroy
    redirect_to games_url, notice: "game was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def game_params
    params.require(:game).permit(:name, :summary, :release_date, :category, :rating, :cover,
                                 :parent_id)
  end
end
