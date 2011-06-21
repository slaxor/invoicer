# -*- encoding : utf-8 -*-
class CustomersController < ApplicationController
  def index
    @customers = current_user.customers
  end

  def show
    @customer = current_user.customers.find(params[:id])
  end

  def new
    @customer = current_user.customers.build
  end

  def edit
    @customer = current_user.customers.find(params[:id])
  end

  def create
    current_user.customers << Customer.create(params[:customer])
  end

  def update
    Customer.find(params[:id]).update_attributes(params[:customer])
  end

  def destroy
    Customer.find(params[:id]).destroy
  end
end

