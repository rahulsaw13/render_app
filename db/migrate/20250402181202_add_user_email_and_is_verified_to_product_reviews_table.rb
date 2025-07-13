class AddUserEmailAndIsVerifiedToProductReviewsTable < ActiveRecord::Migration[7.2]
  def change
    add_column :product_reviews, :email, :string
    add_column :product_reviews, :is_verified, :integer
    add_column :product_reviews, :name, :string
  end
end
