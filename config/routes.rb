# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

require "sidekiq/web"
require "sidekiq-scheduler/web"

Rails.application.routes.draw do
  Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    Rack::Utils.secure_compare(
      ::Digest::SHA256.hexdigest(user),
      ::Digest::SHA256.hexdigest(Rails.application.credentials.config[:SIDEKIQ_USER])
    ) &
    Rack::Utils.secure_compare(
      ::Digest::SHA256.hexdigest(password),
      ::Digest::SHA256.hexdigest(Rails.application.credentials.config[:SIDEKIQ_PASSWORD])
    )
  end

  mount ActionCable.server => "/cable"
  mount Sidekiq::Web => "/sidekiq"

  favicon_redirect = redirect do |_params, _request|
    ActionController::Base.helpers.asset_url(::Invoika::Favicon.main)
  end

  get "favicon.png", to: favicon_redirect
  get "favicon.ico", to: favicon_redirect

  devise_for :users,
             path: "auth",
             path_names: {
               sign_in: "sign-in", sign_out: "sign-out", confirmation: "verification",
               sign_up: "sign-up"
             },
             controllers: {
               sessions: "user/sessions",
               confirmations: "user/confirmations",
               passwords: "user/passwords",
               unlocks: "user/unlocks",
               registrations: "user/registrations"
             }

  concern :toggleable do
    collection do
      get :active
      get :inactive
    end

    member do
      patch :activate
      patch :deactivate
    end
  end

  authenticated :admin do

  end

  authenticated :user do
    resource :company, except: [:new, :create, :destroy]
    resource :dashboard, only: :show
    resource :profile, only: [:show, :edit, :update] do
      delete :remove_avatar, path: "remove-avatar", on: :member
    end
    resource :user_preference, path: "preference", only: [:show, :edit, :update] do
      collection do
        get :change_locale, path: "change-locale"
        patch :update_locale, path: "update-locale"
        patch :update_color_scheme, path: "update-color-scheme"
      end
    end

    resources :categories, except: :show, param: :uuid, concerns: :toggleable
    resources :taxes, except: :show, param: :uuid, concerns: :toggleable
    resources :products, param: :uuid, concerns: :toggleable do
      delete :remove_image, path: "remove-image", on: :member
    end
    resources :quotes, param: :uuid do
      collection do
        get :draft
        get :converted
        get :accepted
      end
    end
    resources :invoices, param: :uuid do
      collection do
        get :draft
        get :unpaid
        get :paid
        get :overdue
      end
    end
  end

  root to: "dashboards#show"

  resources :states, only: :index
  resources :cities, only: :index

  match "*unmatched_route", to: "application#not_found", via: :all, constraints: ::UnmatchedRouteConstraint.new
end
