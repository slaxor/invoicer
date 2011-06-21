# -*- encoding : utf-8 -*-
class InvoiceItemsController < ApplicationController
  def new
    @invoice_item = InvoiceItem.new
  end

  def edit
    @invoice_item = Invoice.find(params[:id]).invoice_items.find(params[:invoice_item][:id])
  end

  def create
    Invoice.find(params[:id]).invoice_items << InvoiceItem.create(params[:invoice_item])
  end

  def update
    Invoice.find(params[:id]).invoice_items.find(params[:invoice_item][:id]).update_attributes(params[:invoice_item])
  end

  def destroy
    Invoice.find(params[:id]).destroy
  end
end

