var InvoiceItem = Backbone.Model.extend({
});

var InvoicingParty = Backbone.Model.extend({
});

var Customer = Backbone.Model.extend({
});

var Invoice = Backbone.Model.extend({
  initialize: function() {
    if(this.paid) {
      this.attributes['status'] = 'paid';
    } else {
      if(Date.parse(this.due_on) < new Date) {
       this.attributes['status'] = 'overdue';
      } else {
       this.attributes['status'] = 'unpaid';
      }
    }
  }
});

var InvoiceCollection = Backbone.Collection.extend({
  model: Invoice,
  url: function() {
    return location + '/customers/' + this.customer_id + '/invoices';
  }
});

var CustomerCollection = Backbone.Collection.extend({
  model: Customer,
  url: location + '/customers',
  comparator : function (m) { return m.get('name').toLowerCase(); }
});

var InvoicingPartyCollection = Backbone.Collection.extend({
  model: InvoicingParty,
  url: location + '/invoicing_parties'
});

var InvoiceItemCollection = Backbone.Collection.extend({
  model: InvoiceItem,
  url: function() {
    return location + '/customers/' + invoices.customer_id + '/invoices/' + this.invoice_id + '/invoice_items';
  }
});

var InvoicesView = Backbone.View.extend({
  events: {
    'click .name': 'handle_details',
    'click .create': 'handle_create',
    'click .edit': 'handle_edit',
    'click .delete': 'handle_delete',
    'click .delete': 'handle_delete',
    'click .ok': 'handle_ok',
    'click .cancel': 'handle_cancel'
  },
  get_invoice_id: function(e) {return $(e.currentTarget).parent().attr('id').match(/(\d+)$/)[1];},
  invoices_collections: {},

  render: function() {
    $('#invoices').html(_.template(invoices_template, invoices))
    //this.handleEvents();
    return this;
  },
  handle_details: function(e) {
    var invoice_id = this.get_invoice_id(e);
    if(invoice_items.invoice_id !== invoice_id) {
      invoice_items.invoice_id = invoice_id;
      invoice_items.fetch({success: function(){invoice_items_view.render();}});
    }
    $(e.currentTarget).siblings('div').toggleClass('show');
  },
  handle_create: function(e) {
    this.form = this.form || get_template('invoice_form');
    var $invoice_form = $('#invoice-form').html(_.template(this.form, {m: invoices.add().last()}));
    $invoice_form.find('due_on').datepicker({dateFormat: 'yy-mm-dd'});
    $invoice_form.find('printed_at').datepicker();
  },
  handle_edit: function(e) {
    this.form = this.form || get_template('invoice_form');
    var $invoice_form = $('#invoice-form').html(_.template(this.form, {m: invoices.get(this.get_invoice_id(e))}));
  },
  handle_delete: function(e) {
    invoices.get(this.get_invoice_id(e)).destroy();
  },
  handle_ok: function(e) {
    var attributes = $(e.currentTarget).parent().harvest();
    if (id = attributes.id) {
      invoices.get(id).set(attributes).save();
    } else {
      invoices.create(attributes);
    }
    $('#invoice-form').html('');
  },
  handle_cancel: function(e) {
    $('#invoice-form').html('');
  }
});

var InvoicingPartyView = BaseView.extend({
  template: 'invoicing_party',
  form_element: $('#invoicing-party-form'),
});

var CustomerView = Backbone.View.extend({
  events: {
    'click .details': 'handle_details',
    'click .invoices': 'handle_invoices',
    'click .edit': 'handle_edit',
    'click .delete': 'handle_delete'
  },
  initialize: function () {
    this.model.view = this;
    this.template = TemplateResolver.get('customer');
  },
  render: function () {
    $(this.el).append(this.template(this.model.toJSON()) )
    return this;
  },

  handle_details: function () {
    this.$('.details-list').toggleClass('show');
  },

  handle_invoices: function (e) {
    var customer_id = this.model.get('id');
    if(invoices.customer_id !== customer_id) {
      invoices.customer_id = customer_id;
      invoices.fetch({success: function (){invoices_view.render();}});
    }
  },
  handle_edit: function (e) {
    new CustomerFormView({model: this.model, el: $('#customer-form')}).render();
  },
  handle_new: function (e) {
    new CustomerFormView({model: this.model, el: $('#customer-form')}).render();
  },
});

var CustomerFormView = Backbone.View.extend({
  events: {
    'click .ok': 'handle_ok',
    'click .cancel': 'handle_cancel',
    'keypress': 'handle_keypress'
  },

  initialize: function () {
    //_.bindAll(this);
    this.template = TemplateResolver.get('customer_form');
  },

  render: function () {
    $(this.el).html(this.template(_.extend(this.model.toJSON(), {isNew: this.model.isNew()})));
    return this;
  },

  handle_ok: function (e) {
    var attributes = this.el.harvest();
    if (this.model.isNew()) {
      this.model.create(attributes);
    } else {
      this.model.set(attributes).save();
    }
    this.disappear();
  },

  handle_cancel: function (e) {
    this.disappear();
  },

  handle_keypress: function (e) {
    switch(e.keyCode) {
      case 13: // enter
        this.$('button.ok').click()
      break;
      case 27: //escape
        this.$('button.cancel').click()
      break;
    }
  },

  disappear: function () {
    $(this.el).html('');
  }
});

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

var BaseView = Backbone.View.extend({
  events: {
    'click .details': 'handle_details',
    'click .invoices': 'handle_invoices',
    'click .edit': 'handle_edit',
    'click .delete': 'handle_delete'
  },

  initialize: function () {
    console.log('base called');
    this.model.view = this;
    this.template = TemplateResolver.get(this.template);
  },
  render: function () {
    $(this.el).append(this.template(this.model.toJSON()) )
    return this;
  },

  handle_details: function () {
    this.$('.details-list').toggleClass('show');
  },
  handle_edit: function (e) {
    new FormView({model: this.model, el: this.form_element, template: this.template + '_form'}).render();
  },
  handle_new: function (e) {
    new FormView({model: this.model, el: this.form_element, template: this.template + '_form'}).render();
  },
});

var FormView = Backbone.View.extend({
  events: {
    'click .ok': 'handle_ok',
    'click .cancel': 'handle_cancel',
    'keypress': 'handle_keypress'
  },

  initialize: function () {
    this.template = TemplateResolver.get(this.template);
  },

  render: function () {
    $(this.el).html(this.template(_.extend(this.model.toJSON(), {isNew: this.model.isNew()})));
    return this;
  },

  handle_ok: function (e) {
    var attributes = this.el.harvest();
    if (this.model.isNew()) {
      this.model.create(attributes);
    } else {
      this.model.set(attributes).save();
    }
    this.disappear();
  },

  handle_cancel: function (e) {
    this.disappear();
  },

  handle_keypress: function (e) {
    switch(e.keyCode) {
      case 13: // enter
        this.$('button.ok').click()
      break;
      case 27: //escape
        this.$('button.cancel').click()
      break;
    }
  },

  disappear: function () {
    $(this.el).html('');
  }
});

