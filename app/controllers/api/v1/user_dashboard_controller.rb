class Api::V1::UserDashboardController < ApplicationController

  def latest_blogs
    @blogs = Blog.order(created_at: :desc).limit(3)
    if @blogs
      blogs_data = @blogs.map do |blog|
        BlogSerializer.new(blog).serializable_hash[:data][:attributes]
      end
      render json: blogs_data
    else
      render json: { errors: @categories.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def snacks_category
    category = Category.find_by(name: 'Snacks', status: 1)

    if category
      sub_categories = category.sub_categories.where(status: 1)
  
      sub_category_data = SubCategorySerializer.new(sub_categories).serializable_hash[:data].map do |sc|
        sc[:attributes]
      end
  
      render json: sub_category_data
    else
      render json: { errors: ['Category "Snacks" not found or inactive'] }, status: :not_found
    end
  end

  def speciality_category
    category = Category.find_by(name: 'Speciality', status: 1)

    if category
      sub_categories = category.sub_categories.where(status: 1)
  
      sub_category_data = SubCategorySerializer.new(sub_categories).serializable_hash[:data].map do |sc|
        sc[:attributes]
      end
  
      render json: sub_category_data
    else
      render json: { errors: ['Category "Speciality" not found or inactive'] }, status: :not_found
    end
  end

  def gifting_category
    @categories = Category.where(name: 'Gifting').where(status: 1).first.sub_categories
    if @categories
      categories_data = @categories.map do |category|
        CategorySerializer.new(category).serializable_hash[:data][:attributes]
      end
      render json: categories_data
    else
      render json: { errors: @categories.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def all_active_products
    @products = Product.includes(:sub_category, :discount, :inventory).where(status: 1)
  
    if @products.any?
      # Group products by name
      grouped_products = @products.group_by(&:name)
      products_data = grouped_products.map do |name, products|
        product = products.first
        # Collect variants (different weights)
        variants = products.map do |p|
          # Calculate prices
          actual_price = p.price
          discounted_price = if p.discount
                               case p.discount.discount_type
                               when 1 # Percentage Discount
                                 actual_price - (actual_price * p.discount.discount_value / 100)
                               when 2 # Flat Discount
                                 actual_price - p.discount.discount_value
                               else
                                 actual_price
                               end
                             else
                               actual_price
                             end
  
          # Calculate total inventory for the product
          inventory_count = p.inventory&.stock_quantity || 0
  
          {
            product_id: p.id,
            weight: p.weight,
            discountedPrice: discounted_price.round(2),
            actualPrice: actual_price.round(2),
            inventory_count: inventory_count
          }
        end
  
        {
          id: product.id,
          name: name,
          description: product.description,
          image_url: product.image_url,
          subCategoryName: product.sub_category.name,
          status: product.status,
          shelf_life: product.shelf_life,
          variants: variants
        }
      end
  
      render json: products_data
    else
      render json: { errors: ['No products found'] }, status: :unprocessable_entity
    end    
  end  

  def all_categories
    @categories = Category.where(status: 1)
  
    if @categories.present?
      categories_data = @categories.map do |category|
        products = category.sub_categories.joins(:products).select('products.id, products.name')
  
        # Group product IDs by unique name
        grouped_products = products.group_by(&:name)
  
        # Count of unique product names
        unique_product_count = grouped_products.keys.size
  
        {
          category: CategorySerializer.new(category).serializable_hash[:data][:attributes],
          products_count: unique_product_count
        }
      end
  
      render json: categories_data
    else
      render json: { errors: ["No categories found"] }, status: :unprocessable_entity
    end
  end    

  def all_sub_categories
    @sub_categories = SubCategory.where(status: 1)
  
    if @sub_categories.present?
      sub_categories_data = @sub_categories.map do |category|
        {
          category: SubCategorySerializer.new(category).serializable_hash[:data][:attributes],
          products_count: category.products.count
        }
      end
      render json: sub_categories_data
    else
      render json: { errors: ["No categories found"] }, status: :unprocessable_entity
    end
  end
  
  def get_products_by_subcategory
    subcategory_id = params[:subcategory_id]
  
    unless SubCategory.exists?(subcategory_id)
      return render json: { errors: ["Subcategory not found"] }, status: :not_found
    end
  
    products = Product.includes(:sub_category, :discount).where(sub_category_id: subcategory_id, status: 1)
  
    if products.any?
      grouped_products = products.group_by(&:name)
  
      products_data = grouped_products.map do |name, grouped|
        product = grouped.first
  
        variants = grouped.map do |p|
          actual_price = p.price
          discounted_price =
            if p.discount
              case p.discount.discount_type
              when 1
                actual_price - (actual_price * p.discount.discount_value / 100.0)
              when 2
                actual_price - p.discount.discount_value
              else
                actual_price
              end
            else
              actual_price
            end
  
          {
            product_id: p.id,
            weight: p.weight,
            discountedPrice: discounted_price.round(2),
            actualPrice: actual_price.round(2)
          }
        end
  
        {
          id: product.id,
          name: name,
          description: product.description,
          image_url: product.image_url,
          subCategoryName: product.sub_category.name,
          status: product.status,
          shelf_life: product.shelf_life,
          variants: variants
        }
      end
  
      render json: products_data
    else
      render json: { errors: ["No products found for this subcategory"] }, status: :not_found
    end
  end

  def get_subcategories_by_category_name
    category = Category.find_by(name: params[:category_name])
  
    unless category
      return render json: { errors: ["Category not found"] }, status: :not_found
    end
  
    total_unique_product_names = []
  
    subcategories_data = category.sub_categories.map do |subcat|
      products = Product.where(sub_category_id: subcat.id, status: 1)
      unique_names = products.pluck(:name).uniq
  
      total_unique_product_names.concat(unique_names)
  
      {
        id: subcat.id,
        name: subcat.name,
        image_url: subcat.image_url,
      }
    end
  
    render json: {
      category: {
        id: category.id,
        name: category.name,
        subcategories: subcategories_data,
        total_products: total_unique_product_names.uniq.count
      }
    }
  end
  
  def get_products_by_category_name
    category = Category.find_by(name: params[:category_name])
  
    unless category
      return render json: { errors: ["Category not found"] }, status: :not_found
    end
  
    products = Product
                 .includes(:sub_category, :discount)
                 .where(sub_category_id: category.sub_categories.select(:id), status: 1)
  
    if products.empty?
      return render json: { errors: ["No products found for this category"] }, status: :not_found
    end
  
    grouped_products = products.group_by(&:name)
  
    product_data = grouped_products.map do |name, grouped|
      product = grouped.first
  
      variants = grouped.map do |p|
        actual_price = p.price
        discounted_price =
          if p.discount
            case p.discount.discount_type
            when 1
              actual_price - (actual_price * p.discount.discount_value / 100.0)
            when 2
              actual_price - p.discount.discount_value
            else
              actual_price
            end
          else
            actual_price
          end
  
        {
          product_id: p.id,
          weight: p.weight,
          discountedPrice: discounted_price.round(2),
          actualPrice: actual_price.round(2)
        }
      end
  
      {
        id: product.id,
        name: product.name,
        description: product.description,
        image_url: product.image_url,
        subCategoryName: product.sub_category.name,
        status: product.status,
        shelf_life: product.shelf_life,
        variants: variants
      }
    end
  
    render json: product_data
  end  

  def get_products_by_festival_special_name
    fest_special = FestSpecial.find_by(status: 1)

    unless fest_special
      return render json: { errors: ["Festival special not found"] }, status: :not_found
    end
  
    products = fest_special.products
                           .includes(:sub_category, :discount)
                           .where(status: 1)
  
    if products.empty?
      return render json: { errors: ["No products found for this festival special"] }, status: :not_found
    end
  
    grouped_products = products.group_by(&:name)
  
    product_data = grouped_products.map do |name, grouped|
      product = grouped.first
  
      variants = grouped.map do |p|
        actual_price = p.price
        discounted_price =
          if p.discount
            case p.discount.discount_type
            when 1
              actual_price - (actual_price * p.discount.discount_value / 100.0)
            when 2
              actual_price - p.discount.discount_value
            else
              actual_price
            end
          else
            actual_price
          end
  
        {
          product_id: p.id,
          weight: p.weight,
          discountedPrice: discounted_price.round(2),
          actualPrice: actual_price.round(2)
        }
      end
  
      {
        id: product.id,
        name: product.name,
        description: product.description,
        image_url: product.image_url,
        subCategoryName: product.sub_category.name,
        status: product.status,
        shelf_life: product.shelf_life,
        variants: variants
      }
    end
  
    render json: product_data
  end

  def get_products_by_subcategory_name
    subcategory = SubCategory.find_by(name: params[:subcategory_name])
  
    unless subcategory
      return render json: { errors: ["Subcategory not found"] }, status: :not_found
    end
  
    products = Product
                 .includes(:sub_category, :discount)
                 .where(sub_category_id: subcategory.id, status: 1)
  
    if products.empty?
      return render json: { errors: ["No products found for this subcategory"] }, status: :not_found
    end
  
    grouped_products = products.group_by(&:name)
  
    product_data = grouped_products.map do |name, grouped|
      product = grouped.first
  
      variants = grouped.map do |p|
        actual_price = p.price
        discounted_price =
          if p.discount
            case p.discount.discount_type
            when 1
              actual_price - (actual_price * p.discount.discount_value / 100.0)
            when 2
              actual_price - p.discount.discount_value
            else
              actual_price
            end
          else
            actual_price
          end
  
        {
          product_id: p.id,
          weight: p.weight,
          discountedPrice: discounted_price.round(2),
          actualPrice: actual_price.round(2)
        }
      end
  
      {
        id: product.id,
        name: product.name,
        description: product.description,
        image_url: product.image_url,
        subCategoryName: product.sub_category.name,
        status: product.status,
        shelf_life: product.shelf_life,
        variants: variants
      }
    end
  
    render json: product_data
  end

  def nav_menu_list
    @categories = Category.where(status: 1)
    if @categories
      render json: @categories, include: [:sub_categories]
    else
      render json: { errors: @categories.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def add_user_review
    review = ProductReview.new(product_review_params)
    if review.save
      render json: { data: review, message: 'Review has been successfully added'}, status: :created
    else
      render json: { errors: review.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def get_product_review_by_id
    @reviews = ProductReview.includes(:product, :user).where(product_id: params[:id]).order(created_at: :desc)

    if @reviews
      reviews_data = @reviews.map do |review|
        {
          id: review.id,
          rating: review.rating,
          review_text: review.review_text,
          created_at: review.created_at,
          updated_at: review.updated_at,
          email: review.email,
          is_verified: review.is_verified,
          name: review.name,
          image_url: review.image_url,
          product_data: {
            id: review.product.id,
            name: review.product.name + " " + review.product.weight,
            description: review.product.description,
            price: review.product.price
          }
        }
      end
  
      render json: reviews_data
    else
      render json: { errors: @categories.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def get_active_fest_special
    @festivals = FestSpecial.includes(:products).order(created_at: :desc).where(status: 1)
    if @festivals.any?
      festivals_data = @festivals.map do |fest|
        FestSpecialSerializer.new(fest).serializable_hash[:data][:attributes]
      end

      render json: festivals_data
    else
      render json: { errors: ['No festival special found'] }, status: :not_found
    end
  end

  def subscribe_user_by_email
    subscriber = Subscriber.find_or_initialize_by(email: params[:email])

    if subscriber.persisted?
      render json: { message: 'Already subscribed' }, status: :ok
    elsif subscriber.save
      render json: { message: 'Thanks for subscribing!' }, status: :created
    else
      render json: { errors: subscriber.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def send_user_otp
    user = User.find_by(id: params[:user_id]) # or email

    unless user
      return render json: { error: "User not found" }, status: :not_found
    end

    otp = rand(1000..9999)

    user_otp = user.user_otp || user.build_user_otp
    user_otp.phone_otp = otp
    user_otp.expires_at = 5.minutes.from_now
    user_otp.save!

    #Sending Temprory basis otp in mail
    UserMailer.send_otp_email(user, otp).deliver_later

    render json: { data:user, message: "OTP sent successfully" }, status: :ok
  end

  def verify_user_otp
    user = User.find_by(id: params[:user_id])
    return render json: { error: "User not found" }, status: :not_found unless user
  
    user_otp = user.user_otp
    return render json: { error: "OTP not found" }, status: :not_found unless user_otp
  
    if user_otp.expired?
      return render json: { error: "OTP has expired" }, status: :unprocessable_entity
    end
  
    if user_otp.phone_otp.to_s == params[:otp].to_s
      user.update!(is_phone_verified: 1, phone_number: params[:phone_number])
      user_otp.update!(phone_otp: nil) # Clear OTP after verification
      render json: { data: user, message: "OTP verified successfully" }, status: :ok
    else
      render json: { error: "Invalid OTP" }, status: :unprocessable_entity
    end
  end

  def add_contact_details
    @contact_detail = ContactDetail.new(contact_form_params)
    if @contact_detail.save
      render json: { data: @contact_detail, message: 'Contact details has been added'}, status: :created
    else
      render json: { errors: @contact_detail.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def product_review_params
    params.permit(:name, :image, :email, :review_text, :rating, :product_id)
  end

  def contact_form_params
    params.permit(:name, :email, :phone_number, :message, :remember_me)
  end
end