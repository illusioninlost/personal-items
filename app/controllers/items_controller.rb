class ItemsController < ApplicationController


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
end
