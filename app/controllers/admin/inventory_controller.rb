class Admin::InventoryController < Admin::ApplicationController
  before_action :authenticate_admin!
  before_action :set_inventory, only: %i[ show edit update destroy ]
  before_action :set_puzzle_type, only: %i[ show ]
  before_action :set_puzzle_types, only: %i[ new create edit update ]

  # GET /inventory or /inventory.json
  def index
    @inventory = Inventory.all
  end

  # GET /inventory/1 or /inventory/1.json
  def show
  end

  # GET /inventory/new
  def new
    @inventory = Inventory.new
  end

  # GET /inventory/1/edit
  def edit
  end

  # POST /inventory or /inventory.json
  def create
    @inventory = Inventory.new(inventory_params)

    respond_to do |format|
      if @inventory.save
        format.html { redirect_to admin_inventory_path(@inventory), notice: "Inventory was successfully created." }
        format.json { render :show, status: :created, location: @inventory }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventory/1 or /inventory/1.json
  def update
    respond_to do |format|
      if @inventory.update(inventory_params)
        format.html { redirect_to admin_inventorypath(@inventory), notice: "Inventory was successfully updated." }
        format.json { render :show, status: :ok, location: @inventory }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventory/1 or /inventory/1.json
  def destroy
    @inventory.destroy!

    respond_to do |format|
      format.html { redirect_to admin_inventory_path, status: :see_other, notice: "Inventory was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory
      @inventory = Inventory.find(params[:id])
    end

    def set_puzzle_type
      @puzzle_types = @puzzle.puzzle_type
    end

    def set_puzzle_types
      @puzzle_types = PuzzleType.all
    end

    # Only allow a list of trusted parameters through.
    def inventory_params
      params.require(:inventory).permit(:price_bought_for, :condition, :details, :puzzle_type_id)
    end
end
