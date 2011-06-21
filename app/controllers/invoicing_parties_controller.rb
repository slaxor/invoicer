# -*- encoding : utf-8 -*-
class InvoicingPartiesController < ApplicationController
  def index
    @invoicing_parties = current_user.invoicing_parties.all
  end

  def show
    @invoicing_party = InvoicingParty.find(params[:id])
  end

  def new
    @invoicing_party = InvoicingParty.new
  end

  def edit
    @invoicing_party = InvoicingParty.find(params[:id])
  end

  def create
    @current_user.invoicing_parties << InvoicingParty.new(params[:invoicing_party])
  end

  def update
    InvoicingParty.find(params[:id]).update_attributes(params[:invoicing_party])
  end

  def destroy
    @current_user.invoicing_parties.find(params[:id]).destroy
  end
end
