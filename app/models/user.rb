class User < ApplicationRecord
  has_many :articles
  before_save { self.email = email.downcase}

  validates :username, presence: true, 
            uniqueness: { case_sensitive: false }, 
            length: {minimum: 3, maximum: 25}
  
  VALID_EMAIL_REGEX= /([a-z_.!@#$%^&*0-9]{3,25})@([a-z]{3,20})\.([a-z]){2,7}(\.[a-z]{2,5})?/i
  validates :email, presence: true, 
            uniqueness: { case_sensitive: false }, 
            length: {maximum: 50}, format: { with: VALID_EMAIL_REGEX }
end