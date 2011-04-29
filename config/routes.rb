# -*- encoding : utf-8 -*-
Invoicer::Application.routes.draw do
  devise_for :users

  #resources :user_session
  match '/api/:api_key/:controller/:action' do
    resources :invoices
    resources :invoicing_parties
    resources :customers
  end

  devise_for :users
  resources :users
  resources :invoices
  resources :invoicing_parties
  resources :customers

  root :to => 'users#show'
end
