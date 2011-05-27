var InvoiceItemsView = Backbone.View.extend({
  events: {
    "click .create": "handle_create",
    "click .edit": "handle_edit",
    "click .delete": "handle_delete"
  },
  invoice_items_collections: {},
  render: function() {
    $('#invoice_items').html(_.template(invoice_items_template, invoice_items))
    //this.handleEvents();
    return this;
  },

  handle_create: function(e) {
    console.log($(e.currentTarget));
  },
  handle_edit: function(e) {
    console.log($(e.currentTarget).parent().attr('id').match(/(\d+)$/)[1]);
  },
  handle_delete: function(e) {
    console.log(e);
  }
});

