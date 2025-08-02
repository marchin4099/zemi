Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get 'tweets/outline' => 'tweets#outline' 
  get 'tweets/activity' => 'tweets#activity' 
  get 'tweets/member' => 'tweets#member' 
  get 'tweets/top' => 'tweets#top'
  get 'tweets/question' => 'tweets#question'
  get 'tweets/teacher' => 'tweets#teacher'
  get 'tweets/mypage' => 'tweets#mypage'
  get 'tweets/newmypage' => 'tweets#newmypage'
  get 'contacts/done' => 'contacts#done'
  get 'letters/new' => 'letters#new'
  get 'letters/:id' => 'letters#show',as: 'letter'
  get 'tweets/new' => 'tweets#new'
  get 'tweets/:id' => 'tweets#show',as: 'tweet'
  get 'students/new' => 'students#new'
  get 'students/:id' => 'students#show',as: 'student'
  get 'plans/new' => 'plans#new'
  get 'plans/:id' => 'plans#show',as: 'plan'

  namespace :devise do
  get 'tweets/top', to: 'tweets#top'
  get 'tweets/outline' => 'tweets#outline' 
  get 'tweets/question' => 'tweets#question'
  get 'tweets/teacher' => 'tweets#teacher'
  get 'tweets/mypage' => 'tweets#mypage'
  get 'tweets/newmypage' => 'tweets#newmypage'
  get 'plans/index' => 'plans#index'
  get 'students/index' => 'students#index'
  get 'tweets/index' => 'tweets#index'
  get 'letters/index' => 'letters#index'
  get 'contacts/new' => 'contacts#new'

  end
  # Defines the root path route ("/")
  # root "posts#index"
  resources :tweets 
  resources :letters
  resources :students
  resources :plans
  resources :contacts
  root 'tweets#top'
  
end
