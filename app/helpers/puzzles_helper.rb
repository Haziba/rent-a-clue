module PuzzlesHelper
  def user_completed_puzzle?(puzzle:)
    return false unless current_user

    current_user.ever_rented?(puzzle: puzzle)
  end
end
