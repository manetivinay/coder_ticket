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

  def store_path(path)
    session[:path] = path
  end

  def restore_path
    redirect_path = session[:path] ||= root_path
    session[:path] = nil
    redirect_path
  end
end