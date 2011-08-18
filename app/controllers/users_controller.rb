class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :index] #Предфильтр авторизованности
  before_filter :correct_user, :only => [:edit, :update] #Предфильтр 'правильности' пользователя.

  def new
    @user = User.new
  end

  #Функция вызывается при попытке создания нового пользователя
  def create
    @user = User.new(params[:user])# :user это хеш содержаший все необходимые для регистрации данные
    if @user.save
      sign_in @user #Куки после регистрации
      flash[:success] = "Welcome Minecraft"
      redirect_to @user
    else
      render 'new'
    end
  end

#Профиль пользователя
  def show
    @user = User.find(params[:id])
  end
#Страниуа редактирование пользователя
  def edit
    @user = User.find(params[:id])
  end

#Обновление данных пользователя
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Update"
      redirect_to @user
    else
      render 'edit'
    end
  end

#Страница пользователей
  def index
    @users = User.all
  end

  private
#Проверяем авторизованли пользователь
  def authenticate
    deny_access unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

end

