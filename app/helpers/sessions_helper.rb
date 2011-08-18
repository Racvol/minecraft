module SessionsHelper

#Создаем куки используя id пользователя и соль
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

#Присвоение переменной экземпляра @current_user пользоватяля
  def current_user=(user)
    @current_user = user
  end

#Поиск текущего пользователя по remember_token.
#Вызывает метод user_from_remember_token при первом вызове которого вызывается current_user, но при последующих вызовах возвращается @current_user без вызова user_from_remember_token.
  def current_user
    @current_user ||= user_from_remember_token
  end

#Пользователь является вошедшим, если current_user не является nil
  def signed_in?
    !current_user.nil?
  end

#Удаляем remember token и устанавливаем текущего пользователя равным nil
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

#Вспомогательная функция выполняется при попытке неавторизованного пользователя получить доступ к профилю пользователя.
  def deny_access
    store_location #запоминаем адрес
    redirect_to signin_path, :notice => ";ldsfs"
  end

  def current_user?(user)
    user == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  private


  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end

#Вспомагательная функция помагающая избежать проблем если куки вернет nil
  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end

  def store_location
    session[:return_to] = request.fullpath #Вешаем на ключ :return_to хеша session
  end

  def clear_return_to
      session[:return_to] = nil #Чистим хеш
  end

end

