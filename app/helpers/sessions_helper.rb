module SessionsHelper
  def current_user_id
    session[:user_id]
  end

  def store_user_id(id)
    session[:user_id] = id
  end

  def clear_user_id
    session[:user_id] = nil
  end
end