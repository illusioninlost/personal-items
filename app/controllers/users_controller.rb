class UsersController < ApplicationController


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
