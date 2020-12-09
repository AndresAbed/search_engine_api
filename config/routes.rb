Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      post '/search', to: 'main#search', as: 'search'
    end
  end
end
