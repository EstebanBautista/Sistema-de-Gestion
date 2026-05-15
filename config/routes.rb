Rails.application.routes.draw do
  root "ordenes#index"

  resources :clientes do
    member do
      patch :archivar
    end
  end

  resources :ordenes do
    member do
      patch :archivar
      patch :cambiar_estado
      get   :descargar_pdf
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
