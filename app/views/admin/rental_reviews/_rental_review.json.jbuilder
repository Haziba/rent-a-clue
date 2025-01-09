json.extract! rental_review, :id, :rental_id, :condition, :details, :created_at, :updated_at
json.url rental_review_url(rental_review, format: :json)
