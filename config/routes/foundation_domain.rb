resources :speakers, only: :index
resources :conferences, only: %i[index show new create edit update destroy]
resources :talks, only: :index
