module SessionTimeout

  def check_session_expiry
    if !session[:expiry_time].nil? and session[:expiry_time] < Time.now
      # Session has expired.
      expire_session
    else
      # Assign a new expiry time
      session[:expiry_time] = new_session_timeout
      return true
    end
  end

  def check_session_ip_binding
    if !session[:session_ip].nil? and session[:session_ip] != request.headers['REMOTE_ADDR']
      # client IP has changed
      expire_session
    else
      # Assign client IP 
      session[:session_ip] = request.headers['REMOTE_ADDR']
      return true
    end
  end

  def expire_session
    reset_session
    session.close
    session_expired
    return false
  end

  # def check_session_browser_signature_binding
#     if !session[:session_browser_signature].nil? and session[:session_browser_signature] != "something"
#       # browser signature has changed
#       reset_session
#       session_expired
#       return false
#     else
#       # Assign a browser signature
#       session[:session_browser_signature] = ""
#       return true
#     end
#   end

  
  def session_expired
    render :text => "session expired"
  end

  def new_session_timeout
    30.minutes.from_now
  end

end
