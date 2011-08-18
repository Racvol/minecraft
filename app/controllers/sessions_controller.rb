class SessionsController < ApplicationController
  #Вход (страница для входа) signin_path
  def new
  end

  #Создание новой сесии sessions_path
  def create
    user = User.authenticate(params[:session][:name],
                             params[:session][:password])
    if user.nil?
      flash.now[:error]= "Invalid nick/email"
      render 'new'
    else
      sign_in user #запускаем пользователя с помошью данной функции
      redirect_back_or user # перенаправляем на страницу профиля или на запрашиваемый ранее url
    end

  end

  #Выход (удаление сесии) signout_path
  def destroy
    sign_out
    redirect_to root_path
  end

end

