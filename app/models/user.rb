class User < ApplicationRecord
  has_one :employee
  has_one :customer
  has_one :courier
  has_many :restaurants
  validates_associated :employee, :customer, :restaurants
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
