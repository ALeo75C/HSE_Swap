class MinorsController < ApplicationController
  before_action :set_minor, only: [:show, :edit, :update, :destroy]

  # GET /minors
  # GET /minors.json
  def index
    @minors = Minor.all
  end

  # GET /minors/1
  # GET /minors/1.json
  def show
  end

  # GET /minors/new
  def new
    @minor = Minor.new
  end

  # GET /minors/1/edit
  def edit
  end

  # POST /minors
  # POST /minors.json
  def create
    @minor = Minor.new(minor_params)

    respond_to do |format|
      if @minor.save
        format.html { redirect_to @minor, notice: 'Minor was successfully created.' }
        format.json { render :show, status: :created, location: @minor }
      else
        format.html { render :new }
        format.json { render json: @minor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /minors/1
  # PATCH/PUT /minors/1.json
  def update
    respond_to do |format|
      if @minor.update(minor_params)
        format.html { redirect_to @minor, notice: 'Minor was successfully updated.' }
        format.json { render :show, status: :ok, location: @minor }
      else
        format.html { render :edit }
        format.json { render json: @minor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /minors/1
  # DELETE /minors/1.json
  def destroy
    @minor.destroy
    respond_to do |format|
      format.html { redirect_to minors_url, notice: 'Minor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_minor
      @minor = Minor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def minor_params
      params.require(:minor).permit(:title, :kredits, :deskription, :location)
    end
end
