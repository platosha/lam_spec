<%= app_name.titleize %>::Application.routes.draw do
  scope "<%= app_name%>" do
    resources :pages
    root :to => "pages#index"
  end  
end
