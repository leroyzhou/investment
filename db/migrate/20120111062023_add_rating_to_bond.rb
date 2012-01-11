class AddRatingToBond < ActiveRecord::Migration
  def change
    add_column :bonds,:rating, :string
  end
end
