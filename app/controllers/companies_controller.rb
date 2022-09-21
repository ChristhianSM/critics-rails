class CompaniesController < ApplicationController
  # Esto lo que haces es buscar la funcion set_company y busca el id del departamento, es para no repetir esa linea de codigo que siempre la tenemos que usar.
  before_action :set_company, only: %i[show edit update destroy]

  # GET /companys
  def index
    @companies = Company.all
  end

  # GET /companys/1
  def show; end

  # GET /companys/new
  def new
    @company = Company.new
    @image = false
  end

  # GET /companys/:id/edit
  def edit
    @image = true
  end

  # POST /companys
  def create
    @company = Company.new(company_params)
    unless @company.cover.attached?
      @company.cover.attach(io: File.open("app/assets/images/random_company.png"), filename: "game_cover")
    end

    if @company.save
      # @company  -> ira a listado de departamentos
      redirect_to companies_url, notice: "company was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companys/:id
  def update
    if @company.update(company_params)
      redirect_to companies_url, notice: "company was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /companys/:id
  def destroy
    @company.destroy
    redirect_to companies_url, notice: "company was successfully destroyed."
  end

  def destroy_involved_company
    game = params[:game_id]
    company = InvolvedCompany.find_by(game_id: params[:game_id], company_id: params[:company_id])
    if params[:developer]
      company.developer = false
    else
      company.publisher = false
    end
    company.save
    redirect_to game_path(game), notice: "Company deleted correctly"
  end

  def create_involved_company
    game = params[:game_id]
    company = InvolvedCompany.find_by(game_id: params[:game_id], company_id: params[:company])
    company ||= InvolvedCompany.new(game_id: params[:game_id], company_id: params[:company])

    if params[:developer]
      company.developer = true
    else
      company.publisher = true
    end
    company.save
    redirect_to game_path(game), notice: "Company Added correctly"
  end

  def critics; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_company
    @company = Company.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def company_params
    params.require(:company).permit(:name, :description, :start_date, :country, :cover)
  end
end
