# coding: utf-8
Factory.define :random_invoice_item, :class => InvoiceItem do |f|
  f.association :invoice, :factory => :random_invoice
  f.price 123
  f.pricing_unit 'Stunden'
  f.pricing_strategy 'hourly'
  f.vat_rate 0.19
  f.description { Faker::Lorem.sentence }
  f.started_at { Time.now - 24.hours }
  f.ended_at { Time.now - 16.hours }
end

