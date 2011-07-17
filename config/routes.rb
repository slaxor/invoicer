# -*- encoding : utf-8 -*-
Invoicer::Application.routes.draw do
  devise_for :users
  resources :users do
    member do
      post :import
      get :export
    end
  end

  resources :invoices do
    member do
      put 'handle_workflow_event/:event', :action => :handle_workflow_event
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
