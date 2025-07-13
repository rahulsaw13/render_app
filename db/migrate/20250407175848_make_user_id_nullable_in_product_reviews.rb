class MakeUserIdNullableInProductReviews < ActiveRecord::Migration[7.2]
  def change
    change_column_null :product_reviews, :user_id, true
  end
end
