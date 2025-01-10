class Admin::RentalReviewsController < Admin::ApplicationController
  before_action :set_rental
  before_action :set_rental_review, only: %i[ show edit update destroy ]
  before_action :create_unless_rental_review, except: %i[ new create ]
  before_action :update_if_rental_review, only: %i[ new create ]

  # GET /rental_reviews or /rental_reviews.json
  def index
    @rental_reviews = RentalReview.all
  end

  # GET /rental_reviews/1 or /rental_reviews/1.json
  def show
  end

  # GET /rental_reviews/new
  def new
    @rental_review = RentalReview.new(rental_id: @rental.id)
  end

  # GET /rental_reviews/1/edit
  def edit
  end

  # POST /rental_reviews or /rental_reviews.json
  def create
    @rental_review = RentalReview.new(rental_review_params.merge(rental_id: @rental.id))
    pp params

    respond_to do |format|
      if @rental_review.save
        if params[:result] == 'Pass'
          format.html { redirect_to admin_root_path, notice: "Rental review was successfully created." }
          format.json { render :show, status: :created, location: @rental_review }
        else
          format.html { redirect_to new_admin_rental_reviews_fines_path(rental_id: @rental.id), notice: "Rental review was successfully created." }
          format.json { render :show, status: :created, location: @rental_review }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rental_review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rental_reviews/1 or /rental_reviews/1.json
  def update
    respond_to do |format|
      if @rental_review.update(rental_review_params)
        if params[:result] == 'Pass'
          format.html { redirect_to admin_root_path, notice: "Rental review was successfully updated." }
          format.json { render :show, status: :created, location: @rental_review }
        else
          format.html { redirect_to new_admin_rental_reviews_fines_path(rental_id: @rental.id), notice: "Rental review was successfully updated." }
          format.json { render :show, status: :created, location: @rental_review }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rental_review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rental_reviews/1 or /rental_reviews/1.json
  def destroy
    @rental_review.destroy!

    respond_to do |format|
      format.html { redirect_to admin_root_path, status: :see_other, notice: "Rental review was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rental_review
      @rental_review = @rental.review
    end

    def set_rental
      @rental = Rental.find(params[:rental_id])
    end

    def create_unless_rental_review
      redirect_to new_admin_rental_reviews_path(@rental) unless @rental_review
    end

    def update_if_rental_review
      redirect_to edit_admin_rental_reviews_path(@rental) if @rental_review
    end

    # Only allow a list of trusted parameters through.
    def rental_review_params
      params.require(:rental_review).permit(:rental_id, :condition, :details, :result, images: [])
    end
end
