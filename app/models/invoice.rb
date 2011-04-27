# -*- encoding : utf-8 -*-
class Invoice
  include Mongoid::Document

  referenced_in :customer
  referenced_in :invoicing_party
  embeds_many :invoice_items

  field :number, :type => String
  field :currency, :type => String
  field :covering_text, :type => String
  field :paid, :type => Boolean, :default => false
  field :due_on, :type => Date
  field :printed_at, :type => DateTime

  attr_accessible :customer_id, :number, :currency, :covering_text, :invoicing_party_id, :paid, :due_on, :printed_at, :invoice_items

  def set_default_number
    self.number = format('%s-%s%0.3i', customer.number, Time.now.to_s(:month_stamp), self.class.count(:conditions => {:customer_id => customer_id}))
  end

  def hours
    invoice_items.map(&:hours).sum
  end

  def amount
    invoice_items.map(&:amount).sum
  end

  def vat_amount
    invoice_items.map(&:vat_amount).sum
  end

  def gross_amount
    invoice_items.map(&:gross_amount).sum
  end
end

