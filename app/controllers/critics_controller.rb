class CriticsController < ApplicationController
  before_action :set_critic, only: %i[show edit update destroy]

  def index
    @critic = Critic.new
    @flag = "game"
    if params[:game_id]
      @game = Game.find(params[:game_id])
      @critics = @game.critics.order(created_at: :desc)
    else
      @company = Company.find(params[:company_id])
      @critics = @company.critics.order(created_at: :desc)
      @flag = "company"
    end
  end

  # GET /critics/1
  def show; end

  # GET /critics/new
  def new
    @critic = Critic.new
  end

  # GET /critics/1/edit
  def edit
    @critic = Critic.find(params[:id])
    if params[:flag] == "game"
      @flag = "game"
      @game = Game.find(params[:model_id])
      @critics = @game.critics.all
    else
      @flag = "company"
      @company = Company.find(params[:model_id])
      @critics = @company.critics.all
    end
    render :index
  end

  # POST /critics
  # POST employees/:employee_id/critics
  # POST departments/:department_id/critics
  def create 
    if params[:game_id]
      criticable = Game.find(params[:game_id])
    elsif params[:company_id]
      criticable = Company.find(params[:company_id])
    end
    @critic = Critic.new(critic_params)
    @critic.user = current_user
    if current_user.role == "admin"
      @critic.approve = true
    end
    
    @critic.criticable = criticable # id type
    if @critic.save
      if @critic.criticable_type == "Company"
        redirect_to company_critics_path(@critic.criticable_id),
                    notice: "Critic was successfully created."
      else
        redirect_to game_critics_path(@critic.criticable_id),
                    notice: "Critic was successfully created."
      end
    else
      if @critic.criticable_type == "Company"
        redirect_to company_critics_path(@critic.criticable_id),
                    alert: "Critic must have title and body."
      else
        redirect_to game_critics_path(@critic.criticable_id),
                    alert: "Critic must have title and body."
      end
    end
  end

  # PATCH/PUT /critics/1
  def update
    if params[:game_id]
      if @critic.update(critic_params)
        redirect_to game_critics_path(@critic.criticable_id), notice: "Critic was successfully updated."
      else
        redirect_to game_critics_path(@critic.criticable_id), status: :unprocessable_entity, alert: "Critic must have title and body."
      end
    else
      if @critic.update(critic_params)
        redirect_to company_critics_path(@critic.criticable_id), notice: "Critic was successfully updated."
      else
        redirect_to company_critics_path(@critic.criticable_id), status: :unprocessable_entity, alert: "Critic must have title and body."
      end
    end
    
  end

  # DELETE /critics/1
  def destroy
    @critic = Critic.find(params[:id])
    @critic.destroy
    redirect_to game_critics_path(@critic.criticable_id), status: :see_other, notice: "Critic was deleted."
  end

  def approve
    critic = Critic.find(params[:critic_id])
    critic.approve = true
    if critic.save
      if critic.criticable_type == "Company"
        redirect_to company_critics_path(critic.criticable_id),
                    notice: "Critic was approved."
      else
        redirect_to game_critics_path(critic.criticable_id),
                    notice: "Critic was approved ."
      end
    end
    

  end
  

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_critic
    @critic = Critic.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def critic_params
    params.require(:critic).permit(:body, :title, :user_id)
  end
end
