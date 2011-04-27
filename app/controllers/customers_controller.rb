# -*- encoding : utf-8 -*-
class CustomersController < ApplicationController
  def index
    @customers = current_user.customers
    respond_to do |format|
      format.html
      format.json  { render :json => @customers }
    end
  end

  def show
    @customer = current_user.customers.find(params[:id])
    respond_to do |format|
      format.html
      format.json  { render :json => @customer }
    end
  end

  def new
    @customer = current_user.customers.build
    respond_to do |format|
      format.html
      format.json  { render :json => @customer }
    end
  end

  def edit
    @customer = current_user.customers(params[:id])
  end

  def create
    @customer = Customer.new(params[:customer])
    current_user.customers << @customer
    respond_to do |format|
      if @customer.save
        format.html { redirect_to(user_customers_path(current_user), :notice => 'Customer was successfully created.') }
        format.json  { render :json => @customer, :status => :created, :location => @customer }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @customer = Customer.find(params[:id])
    respond_to do |format|
      if @customer.update(params[:customer])
        format.html { redirect_to(user_customers_path(current_user), :notice => 'Customer was successfully updated.') }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to(user_customers_path(current_user)) }
      format.json  { head :ok }
    end
  end
end
