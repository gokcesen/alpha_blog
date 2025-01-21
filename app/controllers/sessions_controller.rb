class SessionsController < ApplicationController
  def new
    
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      respond_to do |format|
        format.turbo_stream do
          flash[:notice] = "Logged in successfully"
          redirect_to user
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = "Invalid email/password combination"
          render turbo_stream: turbo_stream.replace("flash-messages", partial: "shared/flash")
        end
        format.html do
          render :new, status: :unprocessable_entity
        end
      end
    end 
  end
  

  def destroy
    session[:user_id] = nil
    respond_to do |format|
      format.turbo_stream do
        flash.now[:alert] = "Logged out"
        #render turbo_stream: turbo_stream.replace("flash-messages", partial: "shared/flash")
        redirect_to root_path
      end
    end
  end
end
