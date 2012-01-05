class AddAdminIndex < ActiveRecord::Migration

  def self.up
    add_index("admins", "username")
  end

  def self.down
    remove_index("admins", "username")
  end
  
end
