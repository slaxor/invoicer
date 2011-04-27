# coding: utf-8
Factory.define :random_user, :class => User do |f|
  f.email { Faker::Internet.email }
  f.password 'password'
  f.password_confirmation 'password'
end

