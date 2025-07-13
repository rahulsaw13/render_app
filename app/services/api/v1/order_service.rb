module Api
  module V1
    class OrderService
      def self.create_order(params)
        ActiveRecord::Base.transaction do
          # Step 1: Handle shipping address logic
          shipping_address = if params[:shipping_address_id].present?
                               Address.find(params[:shipping_address_id])
                             else
                               create_shipping_address(params[:shipping_address], params[:user_id])
                             end

          # Step 2: Handle the coupon logic
          coupon = if params[:coupon].present?
                     validate_coupon(params[:coupon])
                   end

          # Step 3: Create the order
          order = Order.new(
            user_id: params[:user_id],
            tax_price: params[:tax_price],
            handling_fee: params[:handling_fee],
            billing_address_id: params[:billing_address_id] ? params[:billing_address_id] : 2,
            payment_status: params[:payment_status],
            order_status: params[:order_status],
            payment_mode: params[:payment_mode],
            shipping_address_id: shipping_address.id
          )

          raise "Order creation failed" unless order.save

          # Step 4: Process the products (do NOT deduct inventory here)
          total_price = 0
          params[:products].each do |product_data|
            product = Product.find(product_data[:product_id])
            price = product.price
            total_price += price * product_data[:qty]

            OrderItem.create!(
              order_id: order.id,
              product_id: product.id,
              quantity: product_data[:qty],
              price: price
            )
          end

          # Step 5: Update total price
          order.update!(total_price: total_price)

          return order
        rescue StandardError => e
          raise ActiveRecord::Rollback, e.message
        end
      end

      def self.accept_payment!(order_id)
        ActiveRecord::Base.transaction do
          begin
            order = Order.includes(order_items: :product).find(order_id)

            unless order.payment_status.to_s.downcase == "pending"
              raise "Order already paid or not pending. Current status: #{order.payment_status}"
            end

            order.order_items.each do |item|
              inventory = Inventory.find_by(product_id: item.product_id)
              raise "Inventory not found for product ID #{item.product_id}" unless inventory

              if inventory.stock_quantity < item.quantity
                product_name = item.product&.name || "Unknown"
                raise "Insufficient stock for '#{product_name}'. Only #{inventory.stock_quantity} left."
              end

              inventory.update!(stock_quantity: inventory.stock_quantity - item.quantity)
            end

            order.update!(payment_status: "payment accepted")
            return order
          rescue => e
            raise ActiveRecord::Rollback
          end
        end
      end

      private

      def self.create_shipping_address(address_params, user_id)
        address = Address.new(
          flat_no: address_params[:flat_no],
          landmark: address_params[:landmark],
          city: address_params[:city],
          state: address_params[:state],
          zip_code: address_params[:zip_code],
          country: address_params[:country],
          user_id: user_id
        )
        if address.save
          address
        else
          raise "Shipping Address creation failed: #{address.errors.full_messages.join(', ')}"
        end
      end

      def self.validate_coupon(coupon_code)
        coupon = Coupon.find_by(code: coupon_code)
        if coupon.nil?
          raise "Coupon not found"
        elsif coupon.valid_until < Time.current
          raise "Coupon has expired"
        else
          coupon
        end
      end
    end
  end
end
