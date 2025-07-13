class ModifyOrdersTableAddTaxPriceAndHandlingFeeAndChangeBillingAddress < ActiveRecord::Migration[6.0]
  def change
    # Add tax_price and handling_fee columns only if they do not already exist
    unless column_exists?(:orders, :tax_price)
      add_column :orders, :tax_price, :decimal
    end
    
    unless column_exists?(:orders, :handling_fee)
      add_column :orders, :handling_fee, :decimal
    end

    if column_exists?(:orders, :billing_address)
      remove_column :orders, :billing_address
    end
  end
end
