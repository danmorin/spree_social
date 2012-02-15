Spree::UserRegistrationsController.class_eval do

  def create
    super.tap do |resp|
      if @user && @user.new_record? && resp.respond_to?(:session)
        @omniauth = resp.session[:session]
        resp.session[:omniauth] = nil unless @user.new_record?
      end
      if resource.save
        fire_event('spree.user.signup', :user => @user)
      end
    end
  end

  def delete
    session[:omniauth] = nil
    redirect_to signin_path
  end

end
