# -*- encoding : utf-8 -*-
class UserSessionController < ApplicationController
  skip_before_filter :get_current_user, :except => :destroy

  def new
    if @current_user = User.first(:conditions => {:session_id => session[:session_id]}) && session[:session_id]
      redirect_to user_path(@current_user)
    end
  end

  def create
    user = User.first(:conditions => {:login => params[:user_session][:login]})
    if user && user.authentic?(params[:user_session][:password])
      user.session_id = session[:session_id]
      user.save
      @current_user = user
      redirect_to(user_path(@current_user))
    else
      flash[:error] = "sorry i don't know you…"
      redirect_to(new_user_session_path)
    end
  end

  def destroy
    session = {}
    @current_user.update_attribute(:session_id, nil)
  end
end
