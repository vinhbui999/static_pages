class User < ApplicationRecord
    attr_accessor :remember_token

    before_save { self.email = email.downcase }
    validates :name, presence: true, length: {maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    
    validates :email, presence: true, length: {maximum: 255}, format:{ with: VALID_EMAIL_REGEX},
    uniqueness: true
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }

    #if we use save in this, it will false, since we didn't provide password for validation. only update work

    #return the hash digest of the given string
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    #return a random token
    def User.new_token
        SecureRandom.urlsafe_base64
    end

    #Remember a user in the db for use in persistent sessions
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    #Return True if given token matched the remember digest
    def autheticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end
end
