var InvoiceItemCollection = Backbone.Collection.extend({
  model: InvoiceItem,
  url: function() {
    return location + '/customers/' + invoices.customer_id + '/invoices/' + this.invoice_id + '/invoice_items';
  }
});

