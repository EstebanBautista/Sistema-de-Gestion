Rails.application.routes.draw do
  root "ordenes#index"

  resources :clientes do
    collection do
      get :archivados
    end
    member do
      patch :archivar
      patch :desarchivar
    end
  end

  resources :ordenes do
    collection do
      get :archivados
    end
    member do
      patch :archivar
      patch :desarchivar
      patch :cambiar_estado
      get   :descargar_pdf
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
