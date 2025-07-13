Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  
  namespace :api do
    namespace :v1 do
      resources :user_dashboard, controller: 'user_dashboard' do
        collection do
          get :latest_blogs
          get :snacks_category
          get :speciality_category
          get :gifting_category
          get :premium_sub_category
          get :all_categories
          get :all_active_products
          get :nav_menu_list
          post :add_user_review
          post :get_product_review_by_id
          post :get_products_by_subcategory
          get :get_active_fest_special
          post :subscribe_user_by_email
          post :send_user_otp
          post :verify_user_otp
          post :add_contact_details
          get :all_sub_categories
          post :get_subcategories_by_category_name
          post :get_products_by_category_name
          post :get_products_by_subcategory_name
          get :get_products_by_festival_special_name
        end
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :dashboard, controller: 'admin_dashboard' do
        collection do
           get :counts
        end
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :categories do
        collection do
          post :filter
          get :active_categories_list 
        end
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :subscribers do
        collection do
          post :filter
        end
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :contact_details do
        collection do
          post :filter
        end
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :sub_categories do
        collection do
          post :filter
          get :active_sub_categories_list 
        end
      end  
    end
  end

  namespace :api do
    namespace :v1 do
      resources :products do
        collection do
          post :filter
          get :active_product
          get 'download_template', to: 'products#download_template'
          post 'bulk_upload', to: 'products#bulk_upload'
        end
      end
    end
  end
  
  namespace :api do
    namespace :v1 do
      resources :inventories do
        collection do
          post :filter
          get :inventory_product_list 
        end
      end
    end
  end
  
  namespace :api do
    namespace :v1 do
      resources :orders do
        collection do
          post :filter
          post :update_payment_status
        end
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :blogs do
        collection do 
          post :filter
        end
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :product_reviews do
        collection do 
          post :filter
        end
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :fest_specials do
        collection do
          post :filter
          post :update_status
        end
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :coupons do
        collection do 
          post :filter
          post :check_user_coupon
        end
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :discounts do
        collection do
          post :filter
          get :discount_product_list
        end
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          get :get_users_list 
          post :filter
        end
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :addresses do
        member do
          get :get_user_address_list 
        end
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :payment_transactions do
        collection do
          post :create_payment_intent 
          post :verify_payment
        end
      end
    end
  end

end
