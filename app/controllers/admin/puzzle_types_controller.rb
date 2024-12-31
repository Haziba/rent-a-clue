class Admin::PuzzleTypesController < Admin::ApplicationController
  before_action :authenticate_admin!
  before_action :set_puzzle_type, only: %i[ show edit update destroy ]

  # GET /puzzle_types or /puzzle_types.json
  def index
    @puzzle_types = PuzzleType.all
  end

  # GET /puzzle_types/1 or /puzzle_types/1.json
  def show
    @puzzles = @puzzle_type.puzzles
  end

  # GET /puzzle_types/new
  def new
    @puzzle_type = PuzzleType.new
  end

  # GET /puzzle_types/1/edit
  def edit
  end

  # POST /puzzle_types or /puzzle_types.json
  def create
    @puzzle_type = PuzzleType.new(puzzle_type_params)

    respond_to do |format|
      if @puzzle_type.save
        format.html { redirect_to admin_puzzle_types_path(@puzzle_type), notice: "Puzzle type was successfully created." }
        format.json { render :show, status: :created, location: @puzzle_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @puzzle_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /puzzle_types/1 or /puzzle_types/1.json
  def update
    respond_to do |format|
      if @puzzle_type.update(puzzle_type_params)
        format.html { redirect_to admin_puzzle_types_path(@puzzle_type), notice: "Puzzle type was successfully updated." }
        format.json { render :show, status: :ok, location: @puzzle_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @puzzle_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /puzzle_types/1 or /puzzle_types/1.json
  def destroy
    @puzzle_type.destroy!

    respond_to do |format|
      format.html { redirect_to admin_puzzle_types_path, status: :see_other, notice: "Puzzle type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_puzzle_type
      @puzzle_type = PuzzleType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def puzzle_type_params
      params.require(:puzzle_type).permit(:name, :brand, :description)
    end
end
