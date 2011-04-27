# coding: utf-8
Factory.define :random_invoice, :class => Invoice do |f|
  f.association :customer, :factory => :random_customer
  f.association :invoicing_party, :factory => :random_invoicing_party
  f.number { rand(2**32).to_s(36).upcase }
  f.covering_text { Faker::Lorem.paragraph(3) }
  f.paid false
  f.due_on { Time.now }
  f.invoice_items do |ii|
    #{
      ii.price 1234
      ii.pricing_unit 'Stunden'
      ii.pricing_strategy 'hourly'
      ii.currency '€'
      ii.vat_rate 0.19
      ii.description { Faker::Lorem.sentence }
      ii.started_at { Time.now - 24.hours }
      ii.ended_at { Time.now - 16.hours }
      ii.pauses [
        #{
          #description: { Faker::Lorem.sentence },
          #started_at: { Time.now - 21.hours },
          #ended_at: { Time.now - 19.hours }
        #}
      ]
    #}
  #]
  end
end

