class AddMarketToBond < ActiveRecord::Migration
  def change
    add_column :bonds,:market, :string
    remove_column :bonds, :uri
  end
end
