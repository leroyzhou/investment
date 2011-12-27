class CreateBonds < ActiveRecord::Migration
  def change
    create_table :bonds do |t|
      t.string :name, :null => false
      t.string :code, :null => false
      t.string :uri, :null => false
      t.string :issuer
      
      t.float :par, :null => false
      t.string :par_frequency, :null => false      
      t.float :coupon, :null => false
      t.datetime :dated_date , :null => false
      t.float :maturity, :null => false
      t.string :credit_ratings
      t.float :quantity, :null => false
      
      t.string :bond_type , :null => false
      
      t.float :price
      t.float :change
      t.float :change_rate
      t.float :volume
      
      t.timestamps      
    end
    
    add_index :bonds, :code
  end
end
