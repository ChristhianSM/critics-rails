class UsersController < ApplicationController
  def new
  end

  def index
  end

  def show
    redirect_to games_path
  end

  def edit
  end

  def update
    redirect_to root_path
  end

  def destroy
  end
end
