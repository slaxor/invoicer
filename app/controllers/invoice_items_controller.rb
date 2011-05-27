class InvoiceItemsController < ApplicationController
  def index
    @invoice_items =
    respond_to do |format|
      format.html
      format.json  { render :json => @invoices }
    end
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
          :prawn => {:page_size => 'A4', :left_margin => 80, :right_margin => 50, :bottom_margin => 10 }
        )
      end
    end
    @invoice = Invoice.find(params[:id])
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
    @customers = current_user.customers.map {|c| [c.name, c.id]}
    @invoicing_parties = current_user.invoicing_parties.map {|ip| [ip.name, ip.id]}
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
      if @invoice.update_attributes(params[:invoice])
        format.html { redirect_to(@invoice, :notice => 'Invoice was successfully updated.') }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @invoice.errors, :status => :unprocessable_entity }
      end
    end
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
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to(invoices_url) }
      format.json  { head :ok }
    end
  end
  private
  def get_invoice
    @invoice = Invoice.find(params[:invoice_id])
    head :not_allowed unless false #TODO check if current_user is allowed
  end
end
