require 'razorpay'

class Api::V1::PaymentTransactionsController < ApplicationController
  before_action :authenticate_user!

  def create_payment_intent
    Razorpay.setup(ENV['RAZORPAY_KEY_ID'], ENV['RAZORPAY_SECRET'])

    amount = params[:amount].to_i

    if amount <= 0
      render json: { error: "Invalid amount" }, status: :unprocessable_entity
      return
    end

    order = Razorpay::Order.create(
      amount: amount * 100, 
      currency: 'INR',
      receipt: "order_#{SecureRandom.hex(5)}",
      payment_capture: 1
    )

    render json: { id: order.id, amount: order.amount, razorpay_key_id: ENV['RAZORPAY_KEY_ID'] }
  end

  def verify_payment
    Razorpay.setup(ENV['RAZORPAY_KEY_ID'], ENV['RAZORPAY_SECRET'])
  
    generated_signature = OpenSSL::HMAC.hexdigest(
      'SHA256',
      ENV['RAZORPAY_SECRET'],
      "#{params[:razorpay_order_id]}|#{params[:razorpay_payment_id]}"
    )
  
    if generated_signature == params[:razorpay_signature]
      # Mark order as paid in your system
      render json: { success: true }
    else
      render json: { success: false, error: "Invalid signature" }, status: :unauthorized
    end
  end  

end
