# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if current_user.update(params[:user])
        format.html { redirect_to(current_user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => current_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  #ma sehn ob ich suiziduser will
  #def destroy
    #@user = User.find(params[:id])
    #@user.destroy
    #respond_to do |format|
      #format.html { redirect_to(users_url) }
      #format.xml  { head :ok }
    #end
  #end
  #
end
