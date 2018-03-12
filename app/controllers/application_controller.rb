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
      @current_user ||= User.find_by(username: session[:user_id]) if session[:user_id]
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

  post "/login" do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id]=@user.username
      erb :personal
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


  post "/new" do
    @user = current_user
    if params[:item_name] == "" || params[:item_amount] == ""
      redirect to '/new'
    else
      @item = @user.items.build(name: params[:item_name], amount: params[:item_amount])
      @item.save
      erb :edit
    end
  end

  patch "/edit" do
    @user = current_user
    @item = @user.items.last
    @item.update(name: params[:item_name], amount: params[:item_amount])
      erb :personal
    end

    delete "/delete" do
      @user = current_user
      @item = @user.items.last
      @item.delete
      erb :personal
    end

end
