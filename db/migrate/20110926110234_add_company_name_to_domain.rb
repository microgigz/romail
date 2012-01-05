class AddCompanyNameToDomain < ActiveRecord::Migration
  def self.up
    add_column("domains", "company_name", :string)
  end

  def self.down
    remove_column("domains", "company_name", :string)
  end
end
