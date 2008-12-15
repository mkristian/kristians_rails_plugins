module UnrestfulAuthentication

  def logged_in?
    !session[:user_id].nil?
  end

  def current_user
    session[:user] = login_from_session if logged_in? and session[:user].nil?
    session[:user]
  end 

  def current_user=(new_user)
    session[:user_id] = new_user ? new_user.id : nil
    session[:user] = new_user
  end

  def login_required
    if logged_in?
      #if request.method == :post and login
      #  redirect_to request.url, :status => :moved_permanently
      #  false
      #else 
        true
      #end
    else
      if request.method == :get
        session.delete
        login_page
      elsif request.method == :post or request.method == :put or request.method == :delete
        user = login
        if user
          reset_session
          self.current_user = user
          redirect_to request.url, :status => :moved_permanently
        else
          session.delete
          access_denied
        end
      end
      false
    end
  end

  def login
    User.authenticate(params[:username], params[:password])
  end

  def login_from_session
    User.get(session[:user_id])
  end

  def logout
    session.delete
    current_user = nil
  end

  def access_denied
    flash[:notice] = "access_denied" unless flash[:notice]
    render :template => "sessions/login", :status => :unauthorized
  end

  def login_page
    render :template => "sessions/login"
  end

end
