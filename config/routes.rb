# frozen_string_literal: true

Rails.application.routes.draw do
  resources :accounts, only: [:create] do
    member do
      post 'deposit'
      get 'balance'
    end
  end

  post 'saque', to: 'atm#withdraw'
  post 'abastecimento', to: 'atm#load_cash'
end
