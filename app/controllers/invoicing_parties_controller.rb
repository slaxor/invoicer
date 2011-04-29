# -*- encoding : utf-8 -*-
class InvoicingPartiesController < ApplicationController
  # GET /invoicing_parties
  # GET /invoicing_parties.json
  def index
    @invoicing_parties = current_user.invoicing_parties.all
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @invoicing_parties }
    end
  end

  # GET /invoicing_parties/1
  # GET /invoicing_parties/1.json
  def show
    @invoicing_party = InvoicingParty.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @invoicing_party }
    end
  end

  # GET /invoicing_parties/new
  # GET /invoicing_parties/new.json
  def new
    @invoicing_party = InvoicingParty.new

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @invoicing_party }
    end
  end

  def edit
    @invoicing_party = InvoicingParty.find(params[:id])
  end

  def create
    @invoicing_party = InvoicingParty.new(params[:invoicing_party])
    @current_user.invoicing_parties << @invoicing_party
    respond_to do |format|
      if @invoicing_party.save
        format.html { redirect_to(user_invoicing_parties_path(@current_user), :notice => 'Invoicing party was successfully created.') }
        format.json  { render :json => @invoicing_party, :status => :created, :location => @invoicing_party }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @invoicing_party.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @invoicing_party = InvoicingParty.find(params[:id])
    respond_to do |format|
      if @invoicing_party.update(params[:invoicing_party])
        format.html { redirect_to(@invoicing_party, :notice => 'Invoicing party was successfully updated.') }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @invoicing_party.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @invoicing_party = @current_user.invoicing_parties.find(params[:id])
    @invoicing_party.destroy

    respond_to do |format|
      format.html { redirect_to(invoicing_parties_url) }
      format.json  { head :ok }
    end
  end
end
