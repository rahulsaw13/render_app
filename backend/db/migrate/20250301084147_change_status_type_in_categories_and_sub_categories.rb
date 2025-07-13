class ChangeStatusTypeInCategoriesAndSubCategories < ActiveRecord::Migration[7.2]
  def change
    # Change status column from string to integer in categories table with explicit cast
    change_column :categories, :status, :integer, using: 'status::integer'

    # Change status column from string to integer in sub_categories table with explicit cast
    change_column :sub_categories, :status, :integer, using: 'status::integer'
  end
end
