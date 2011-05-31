# -*- encoding : utf-8 -*-
class InvoicingParty
  include Mongoid::Document
  referenced_in :user
  references_many :invoices

  field :name
  field :email
  field :telephone
  field :co_line
  field :street
  field :post_code
  field :city
  field :country
  field :vatid
  field :taxnumber
  field :currency
  field :bank_name
  field :bank_account_number
  field :bank_sort_code
  field :invoice_template
  #field :user_id, ObjectId, :required =>  true

  attr_accessible :name, :email, :telephone, :co_line, :street, :post_code, :city, :country, :vatid, :taxnumber, \
    :currency, :bank_name,:bank_account_number, :bank_sort_code, :invoice_template

  mount_uploader :invoice_template, InvoiceTemplateUploader
end
