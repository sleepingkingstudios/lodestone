# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :projects

  resources :tasks do
    resources :relationships,
      controller: :task_relationships,
      only:       %i[create destroy edit new update]
  end
end
