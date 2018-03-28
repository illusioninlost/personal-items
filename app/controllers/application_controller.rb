require './config/environment'
require 'pry'
class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "yeah"
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
  end


  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    @user = User.new(:username => params[:username], :password => params[:password])
    @user.save
    redirect to "/"
  end

  get "/personal" do
    @user = current_user
    erb :personal
  end

  post "/login" do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id]=@user.id
      redirect to '/personal'
    else
      redirect '/'
    end
  end

  get "/logout" do
    session.destroy
    redirect to '/'
  end

  get  "/new" do
    if logged_in?
      erb :new
    else
      redirect to '/'
    end
  end

  get "/edit/:id" do
    @user = current_user
    @item = @user.items.find_by_id(params[:id])
    erb :edit
  end


  post "/new" do
    @user = current_user
    if params[:item_name] == "" || params[:item_amount] == ""
      redirect to '/new'
    else
      @item = @user.items.build(name: params[:item_name], amount: params[:item_amount])
      @item.save
      redirect to '/personal'
    end
  end

  patch "/edit/:id" do
    @user = current_user
    @item = @user.items.find_by_id(params[:id])
    @item.update(name: params[:item_name], amount: params[:item_amount])
      redirect to '/personal'
    end

    delete "/delete/:id" do
      @user = current_user
      @item = @user.items.find_by_id(params[:id])
      @item.delete
      redirect to '/personal'
    end

end
