# coding: utf-8
Factory.define :random_invoice, :class => Invoice do |f|
  f.association :customer, :factory => :random_customer
  f.association :invoicing_party, :factory => :random_invoicing_party
  f.association :invoice_item, :factory => :random_invoice_item
  f.number { rand(2**32).to_s(36).upcase }
  f.covering_text { Faker::Lorem.paragraph(3) }
  f.due_on { Time.now }
  f.currency '€'
end

