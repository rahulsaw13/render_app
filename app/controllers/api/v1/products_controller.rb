class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_user!
  require 'axlsx'
  require 'rubyXL'

  include ActionController::MimeResponds
  
  def index
    @products = Product.includes(:sub_category, :discount).order(:name)
    if @products
      serialized_data = ProductSerializer.new(@products).serializable_hash[:data]

      # Map the data to only include the fields you want, skipping 'type' and 'attributes'
      products_data = serialized_data.map do |product|
        {
          id: product[:id],
          name: product[:attributes][:name],
          description: product[:attributes][:description],
          image_url: product[:attributes][:image_url],
          sub_category_name: product[:attributes][:sub_category_name],
          status: product[:attributes][:status],
          price: product[:attributes][:price],
          weight: product[:attributes][:weight],
          shelf_life: product[:attributes][:shelf_life],
          final_price: product[:attributes][:price] - product[:attributes][:discounted_price],
          discounted_price: product[:attributes][:discounted_price]
        }
      end

      render json: products_data
    else
      render json: { errors: @products.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def filter
    # Start by including sub_category and discount, and ordering products by name
    @products = Product.includes(:sub_category, :discount).order(created_at: :desc)
    @total = @products.count

    # Apply search filter if the 'search' parameter is present
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @products = @products.where("name ILIKE ? OR description ILIKE ? OR status::text ILIKE ?", search_term, search_term, search_term)
    end
  
    # Apply skip (offset) and limit (pagination)
    skip = params[:skip].to_i || 0    # Default to 0 if no skip parameter is passed
    limit = params[:limit].to_i || 10  # Default to 10 if no limit parameter is passed
  
    @products = @products.offset(skip).limit(limit)
  
    # Serialize using FastJsonapi
    if @products.any?
      serialized_data = ProductSerializer.new(@products).serializable_hash[:data]
  
      # Map the data to include the fields you want, skipping 'type' and 'attributes'
      products_data = serialized_data.map do |product|
        {
          id: product[:id],
          name: product[:attributes][:name],
          description: product[:attributes][:description],
          image_url: product[:attributes][:image_url],
          sub_category_name: product[:attributes][:sub_category_name],
          status: product[:attributes][:status],
          price: product[:attributes][:price],
          weight: product[:attributes][:weight],
          shelf_life: product[:attributes][:shelf_life],
          final_price: product[:attributes][:price] - product[:attributes][:discounted_price],
          discounted_price: product[:attributes][:discounted_price]
        }
      end
  
      render json: {
        data: products_data,
        total: @total
      }
    else
      render json: { errors: "No products found" }, status: :unprocessable_entity
    end
  end  

  def download_template
    # Create a new Excel file
    p = Axlsx::Package.new
    wb = p.workbook

    bold_style = wb.styles.add_style(b: true)
    
    # Create the first sheet
    wb.add_worksheet(name: 'Sheet 1') do |sheet|
      sheet.add_row ['Sub Category', 'Product Name', 'Description', 'Price', 'Weight'], style: bold_style
    end

    # Create the second sheet
    @sub_categories = SubCategory.where(status: 1)
    wb.add_worksheet(name: 'Sheet 2') do |sheet|
      sheet.add_row ['Sub Category Name'], style: bold_style

      @sub_categories.each do |sub_category|
        sheet.add_row [sub_category.name] 
      end
    end

    # Prepare the response as an Excel file
    send_data p.to_stream.read, type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', disposition: 'attachment', filename: 'report.xlsx'
  end

  def bulk_upload
    # Check if file is present
    if params[:file].nil?
      render json: { errors: 'No file uploaded' }, status: :unprocessable_entity and return
    end

    # Load the uploaded file
    uploaded_file = params[:file]
    begin
      # Open the XLSX file using rubyXL
      workbook = RubyXL::Parser.parse(uploaded_file.tempfile)

      # Read the first sheet
      sheet = workbook[0] # Sheet 1

      # Start a transaction to ensure atomicity
      Product.transaction do
        products_data = []

        # Loop through the rows (starting from row 2 to skip header)
        sheet.each_with_index do |row, index|
          next if index == 0  # Skip the first row as it's the header

          # Assuming the columns are: Sub Category, Product Name, Description, Price, Weight
          sub_category_name = row[0].value
          product_name = row[1].value
          description = row[2].value
          price = row[3].value
          weight = row[4].value
          shelf_life = row[5].value

          # Find subcategory by name
          sub_category = SubCategory.find_by(name: sub_category_name)

          # Skip if subcategory is not found
          if sub_category.nil?
            products_data << { product_name: product_name, error: "Subcategory not found: #{sub_category_name}" }
            raise ActiveRecord::Rollback  # Rollback the transaction
          end

          # Create the product
          product = Product.new(
            name: product_name,
            description: description,
            price: price,
            weight: weight,
            shelf_life: shelf_life,
            sub_category_id: sub_category.id,
            status: 1 # assuming 1 means active
          )

          if product.save
            products_data << { product_name: product_name, status: 'Created' }
          else
            products_data << { product_name: product_name, error: product.errors.full_messages.join(', ') }
            raise ActiveRecord::Rollback  # Rollback the transaction if product creation fails
          end
        end

        # If we reached here, all products were successfully saved. Commit the transaction.
        render json: { message: 'Bulk upload completed', results: products_data }
      end

    rescue StandardError => e
      # Catch any errors and rollback the transaction
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def active_product
    @products = Product.includes(:sub_category, :discount).order(:name).where(status: 1)
    if @products
      serialized_data = ProductSerializer.new(@products).serializable_hash[:data]

      # Map the data to only include the fields you want, skipping 'type' and 'attributes'
      products_data = serialized_data.map do |product|
        {
          id: product[:id],
          name: product[:attributes][:name],
          description: product[:attributes][:description],
          image_url: product[:attributes][:image_url],
          sub_category_name: product[:attributes][:sub_category_name],
          status: product[:attributes][:status],
          price: product[:attributes][:price],
          weight: product[:attributes][:weight],
          shelf_life: product[:attributes][:shelf_life],
          final_price: product[:attributes][:price] - product[:attributes][:discounted_price],
          discounted_price: product[:attributes][:discounted_price]
        }
      end

      render json: products_data
    else
      render json: { errors: products.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create
    product = Product.new(product_params)
    if product.save
      render json: { data: product, message: 'Product has been successfully created'}, status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @product = Product.find(params[:id])
    if @product
      render json: ProductSerializer.new(@product).serializable_hash[:data][:attributes]
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    product = Product.find(params[:id])
    if product.update(product_params)
      render json: { data: product, message: 'Category has been successfully updated'}
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    product = Product.find_by(id: params[:id])
    if product.destroy
      head :ok
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.permit(:name, :description, :weight, :shelf_life, :status, :image, :price, :sub_category_id, :shelf_life)
  end
end