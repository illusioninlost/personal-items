require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "yeah"
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

end
