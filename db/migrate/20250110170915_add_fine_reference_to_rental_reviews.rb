class AddFineReferenceToRentalReviews < ActiveRecord::Migration[7.1]
  def change
    add_reference :rental_reviews, :fine, foreign_key: true, type: :uuid
  end
end
