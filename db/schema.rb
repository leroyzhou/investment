# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120113030937) do

  create_table "bonds", :force => true do |t|
    t.string   "name",           :null => false
    t.string   "code",           :null => false
    t.string   "issuer"
    t.float    "par",            :null => false
    t.string   "par_frequency",  :null => false
    t.float    "coupon",         :null => false
    t.datetime "dated_date",     :null => false
    t.float    "maturity",       :null => false
    t.string   "credit_ratings"
    t.float    "quantity",       :null => false
    t.integer  "bond_type",      :null => false
    t.float    "price"
    t.float    "change"
    t.float    "change_rate"
    t.float    "volume"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rating"
    t.string   "market"
  end

  add_index "bonds", ["code"], :name => "index_bonds_on_code"

end
