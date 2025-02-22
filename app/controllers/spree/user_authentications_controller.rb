class Spree::UserAuthenticationsController < Spree::BaseController
  ssl_allowed

  def update
    @user = Spree::User.find(params[:id])

    authorize! :edit, @user, session[:user_access_token]

    session[:user_access_token] = nil

    if @user.update_attributes(params[:user])
      sign_in(@user, :event => :authentication) unless current_user
      redirect_back_or_default(products_path)
    else
      flash.now[:error] = I18n.t(:sign_in_to_associate_with_existing_email)
      render(:template => 'spree/users/merge')
    end
  end

  def destroy
    @auth = current_user.user_authentications.find(params[:id])

    authorize! :destroy, @auth

    @auth.destroy
    flash[:notice] = I18n.t(:successfully_deleted_authentication_source)
    redirect_to account_path
  end
end
