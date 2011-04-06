# -*- encoding : utf-8 -*-
class Customer
  include Mongoid::Document
  referenced_in :user
  references_many :invoices

  field :name
  field :number
  field :email
  field :telephone
  field :co_line
  field :street
  field :post_code
  field :city
  field :country
  #field :user_id

  attr_accessible :name, :number, :email, :telephone, :street, :post_code, :city, :country
end
