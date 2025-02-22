Spree::UserSessionsController.class_eval do
  ssl_allowed
  
  def merge
    # now sign in from the login form
    authenticate_user!

    # prep for all the shifting and do it
    user = Spree::User.find(current_user.id)
    user.user_authentications << Spree::UserAuthentication.find(params[:user_authentication])
    user.save!

    if current_order
      current_order.associate_user!(user)
      session[:guest_token] = nil
    end
    # trash the old anonymous that was created
    Spree::User.destroy(params[:user][:id])

    # tell the truth now
    flash[:alert] = I18n.t(:successfully_linked_your_accounts)
    sign_in_and_redirect(user, :event => :authentication)
  end

end
