class ApplicationController < ActionController::Base
  protected 
  
  def ensure_complete_account!
    return unless signed_in_with_incomplete_account?

    redirect_to_complete_account!
  end

  private

  def signed_in_with_incomplete_account?
    return false unless current_user.present?
    return true if current_user.incomplete_account?

    false
  end

  def redirect_to_complete_account!
    return if request.path == new_contact_path || request.path == new_subscription_path

    return redirect_to new_contact_path unless current_user.contact.present?
    return redirect_to new_subscription_path unless current_user.subscription.present?
  end

  def after_sign_in_path_for(user)
    account_path
  end
end
