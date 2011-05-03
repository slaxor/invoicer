# coding: utf-8
Factory.define :random_pause, :class => Pause do |f|
  f.association :invoice_item, :factory => :random_invoice_item
  f.description { Faker::Lorem.sentence }
  f.started_at { Time.now - 21.hours }
  f.ended_at { Time.now - 19.hours }
end

