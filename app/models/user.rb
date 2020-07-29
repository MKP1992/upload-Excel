class User < ApplicationRecord
	validates_presence_of :first_name, :last_name
	validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 
end
