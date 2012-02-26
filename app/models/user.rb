class User < ActiveRecord::Base
  has_many :authorizations
  validates :name, :presence => true
end
