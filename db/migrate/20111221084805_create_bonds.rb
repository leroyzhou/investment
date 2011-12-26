class CreateBonds < ActiveRecord::Migration
  def change
    create_table :bonds do |t|
      t.string :name, :null => false
      t.string :uri, :null => false
      t.string :code, :null => false
      t.float :price
      t.float :change
      t.float :change_rate
      t.float :volume, :null => false
      t.string :full_name, :null => false
      t.float :circulation, :null => false
      t.float :par, :null => false
      t.float :term, :null => false
      t.float :interest, :null => false
      t.datetime :issue_date, :null => false
      t.string :interest_way, :null => false
      t.timestamps
    end
  end
end
