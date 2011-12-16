class User < ActiveRecord::Base
  has_many :polls, :dependent => :destroy
  has_many :participations, :dependent => :destroy  #FIXME: not sure whether OK if both user and poll can delete a participation
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable
         :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :first_name
  
  validates_presence_of :name, :first_name
  
  def full_name
    self.first_name + ' ' + self.name
  end
end
