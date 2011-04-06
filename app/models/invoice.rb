# -*- encoding : utf-8 -*-
class Invoice
  include Mongoid::Document
  referenced_in :customer
  referenced_in :invoicing_party

  field :number
  field :currency
  field :covering_text
  field :paid
  field :due_on
  field :printed_at
  field :invoice_items
    #field :price
    #field :pricing_strategy
    #field :vat_rate
    #field :description
    #field :started_at
    #field :ended_at
    #field :pauses
      #field :description
      #field :started_at
      #field :ended_at
  attr_accessible :customer_id, :number, :currency, :covering_text, :invoicing_party_id, :paid, :due_on, :printed_at, :invoice_items
end
