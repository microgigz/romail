class CreateDomains < ActiveRecord::Migration
  def self.up
    create_table :domains do |t|
      t.string :domain_name
      t.string :imap_server
      t.boolean :status

      t.timestamps
    end
  end

  def self.down
    drop_table :domains
  end
end
