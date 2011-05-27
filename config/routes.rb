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
  resources :invoices do
    member do
      put :handle_workflow_event
      resource :invoice_items do
        member do
          resource :pauses
        end
      end
    end
  end
  resources :invoicing_parties
  resources :customers

  root :to => 'users#show'
end
