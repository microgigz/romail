class CreateAdmins < ActiveRecord::Migration
  def self.up
    create_table :admins do |t|
      t.string "first_name", :limit => 30
      t.string "last_name", :limit => 30
      t.string "username", :limit => 40
      t.string "password", :limit => 32
      t.string "email", :default => "", :null => false
      t.timestamps
    end
    Admin.create  :first_name => "Rq",
                          :last_name => "Bukhari",
                          :username => "admin",
                          :password => "password",
                          :email => "rq.bukhari@gmail.com"
  end

  def self.down
    drop_table :admins
  end
end
