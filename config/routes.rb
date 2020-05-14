Rails.application.routes.draw do
  devise_for :users, defaults: {format: :json},
             path:             '',
             path_names:       {
                 sign_in:      'login',
                 sign_out:     'logout',
                 registration: 'signup'
             },
             controllers:      {
                 sessions:      'sessions',
                 registrations: 'registrations',
                 passwords:     'passwords',
                 confirmations: 'confirmations'
             }
  scope module: 'api', defaults: {format: :json} do
    namespace :v1 do
      resources :posts , param: :slug do
        resources :post_comments,path: :comments
        post '/like_dislike' => 'posts#like_dislike'
        post '/share' => 'posts#share'
      end
      resources :hashtags , param: :slug do
        post '/follow' => 'hashtags#follow'
        post '/unfollow' => 'hashtags#unfollow'
      end
      resources :advertisements , param: :slug do
        resources :advertisement_comments,path: :comments
        post  '/like_dislike' => 'advertisements#like_dislike'
        post '/share' => 'advertisements#share'
      end

      resources :groups , param: :slug do
        resources :advertisement_comments,path: :comments
        post  '/like_dislike' => 'advertisements#like_dislike'
        post '/share' => 'advertisements#share'
      end
      get "/check_public_url"=>"company_pages#check_public_url"
      resources :company_pages , param: :public_url ,path: :pages do
        resources :advertisement_comments,path: :comments
        post  '/like_dislike' => 'advertisements#like_dislike'
        post '/share' => 'advertisements#share'
      end

      # get '/posts/comments/:post_slug' => 'post_comments#index'

      scope "public_profile/:user_slug" do
      resources :user_work_experiences, :path => 'work_experiences'
      resources :user_educations, :path => 'educations'
      resources :user_accomplishments, :path => 'accomplishments'
      resources :user_website_urls, :path => 'website_urls'
      get "skills"=> 'user_educations#get_skills'
      post "skills"=> 'user_educations#update_skills'
      get "/activities"=> 'users#activities'
      end
      get '/public_profile/:slug'=> 'users#public_profile'
      get '/get_university'=> 'user_educations#get_university'
      post '/public_profile/:slug'=> 'users#save_profile'
    end
  end
  post "/social_login"=>"omniauth_callbacks#common_auth2"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
