class Admin < ActiveRecord::Base

  #  before_create :hash_password

  validates :username, :presence => true
  validates :password, :presence => true, :length => {:minimum => 6}

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  #  def hash_password
  #    self.password = Digest::MD5.hexdigest(self.password)
  #  end
 
end
