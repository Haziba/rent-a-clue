class Fine < ApplicationRecord
  belongs_to :rental_review

  enum reason: { box_damage: 0, broken_fixable: 1, broken_unfixable: 2, dirty: 3 }
end
