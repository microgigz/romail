class Domain < ActiveRecord::Base
  has_attached_file :avatar, :styles => { :medium => "150x120>", :thumb => "100x100>" }
end
