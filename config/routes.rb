<%= app_name.classify %>::Application.routes.draw do
  scope "<%= app_name%>" do
    resources :pages
    root :to => "pages#index"
  end  
end
