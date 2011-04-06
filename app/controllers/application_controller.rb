# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  attr_reader :current_user
  protect_from_forgery
  before_filter :get_current_user
  private
  def get_current_user
    @current_user =  if params[:api_key]
      User.first(:api_keys == params[:api_key]) # XXX inc nicht ==
    else
      User.first(:conditions => {:session_id => session[:session_id]}) unless session[:session_id].nil?
    end
    redirect_to new_user_session_url unless @current_user
  end
end
