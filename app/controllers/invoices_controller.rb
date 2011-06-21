# -*- encoding : utf-8 -*-
class InvoicesController < ApplicationController
  def index
    @invoices = current_user.invoices
  end

  def show
    @invoice = Invoice.find(params[:id], {
      :customer_id.in => current_user.customers.map{|c| c.id},
      :invoicing_party_id => current_user.invoicing_parties.map {|ip| ip.id}
    })
    respond_to do |format|
      filename = "invoice_#{@invoice.customer.name}_#{@invoice.number}".gsub(/[^A-Za-z0-9]/, '_')
      format.json { render :json => @invoice }
      format.html
      format.pdf do
        @invoice.update_attribute(:printed_at, Time.now) unless @invoice.printed_at
        prawnto(
          :filename => "#{filename}.pdf",
          :prawn => {:page_size => 'A4', :left_margin => 80, :right_margin => 50, :bottom_margin => 10}
          #:template => @invoice.pdf_template}
        )
      end
    end
  end

  def new
    @invoice = Invoice.new
  end

  def edit
    @invoice = Invoice.find(params[:id])
    @customers = current_user.customers.map {|c| [c.name, c.id]}
    @invoicing_parties = current_user.invoicing_parties.map {|ip| [ip.name, ip.id]}
  end

  def create
    Invoice.create(params[:invoice])
  end

  def update
    @invoice = Invoice.find(params[:id])
  end

  def handle_workflow_event
    invoice = Invoice.find(params[:id])
    if invoice.current_state.events.keys.include?(params[:event].to_sym)
      render :json => invoice.send("#{params[:event]}!")
    else
      head :unprocessable_entity
    end
  end

  def destroy
    Invoice.find(params[:id]).destroy
  end
end
