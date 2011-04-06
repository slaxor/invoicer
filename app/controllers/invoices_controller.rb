# -*- encoding : utf-8 -*-
class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
    respond_to do |format|
      format.html
      format.json  { render :json => @invoices }
    end
  end

  def show
    debugger
    respond_to do |format|
      @invoice = @current_user.invoices.find(params[:id])
      filename = "invoice_#{@invoice.customer.name}_#{@invoice.number}".gsub(/[^A-Za-z0-9]/, '_')
      format.json { render :json => @invoice }
      format.html
      format.pdf do
        @invoice.update_attribute(:printed_at, Time.now) unless @invoice.printed_at
        prawnto(
          :filename => "#{filename}.pdf",
          :prawn => {:page_size => 'A4', :left_margin => 80, :right_margin => 50, :bottom_margin => 10 }
        )
      end
    end
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      format.html
      format.json  { render :json => @invoice }
    end
  end

  def new
    @invoice = Invoice.new
    respond_to do |format|
      format.html
      format.json  { render :json => @invoice }
    end
  end

  def edit
    @invoice = Invoice.find(params[:id])
  end

  def create
    @invoice = Invoice.new(params[:invoice])

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to(@invoice, :notice => 'Invoice was successfully created.') }
        format.json  { render :json => @invoice, :status => :created, :location => @invoice }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      if @invoice.update(params[:invoice])
        format.html { redirect_to(@invoice, :notice => 'Invoice was successfully updated.') }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to(invoices_url) }
      format.json  { head :ok }
    end
  end
end
