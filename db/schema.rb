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

ActiveRecord::Schema.define(:version => 20121117153358) do

  create_table "invoices", :force => true do |t|
    t.integer  "user_id"
    t.integer  "client_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "paid"
  end

  add_index "invoices", ["client_id"], :name => "index_invoices_on_client_id"
  add_index "invoices", ["paid"], :name => "index_invoices_on_paid"
  add_index "invoices", ["user_id"], :name => "index_invoices_on_user_id"

  create_table "items", :force => true do |t|
    t.text     "details"
    t.float    "hours"
    t.float    "rate"
    t.float    "amount"
    t.integer  "invoice_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.datetime "date"
  end

  add_index "items", ["amount"], :name => "index_items_on_amount"
  add_index "items", ["date"], :name => "index_items_on_date"
  add_index "items", ["details"], :name => "index_items_on_details"
  add_index "items", ["hours"], :name => "index_items_on_hours"
  add_index "items", ["invoice_id"], :name => "index_items_on_invoice_id"
  add_index "items", ["rate"], :name => "index_items_on_rate"
  add_index "items", ["user_id"], :name => "index_items_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.boolean  "admin"
    t.boolean  "client"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "slug"
    t.integer  "phone",              :limit => 8
  end

  add_index "users", ["address"], :name => "index_users_on_address"
  add_index "users", ["admin"], :name => "index_users_on_admin"
  add_index "users", ["city"], :name => "index_users_on_city"
  add_index "users", ["client"], :name => "index_users_on_client"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true
  add_index "users", ["state"], :name => "index_users_on_state"
  add_index "users", ["zip"], :name => "index_users_on_zip"

end
