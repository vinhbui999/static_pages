class User < ApplicationRecord
    has_many :microposts, dependent: :destroy
    has_many :active_relationships, class_name: "Relationship",
                                     foreign_key:"follower_id", 
                                     dependent: :destroy
    has_many :passive_relationships, class_name: "Relationship",
                                        foreign_key: "followed_id",
                                        dependent: :destroy
    has_many :following, through: :active_relationships, source: :followed #this mean override, following array is the set of followed ids
    has_many :followers, through: :passive_relationships, source: :follower
    #dependent micropost to be destroyed when user destroy
    attr_accessor :remember_token, :activation_token, :reset_token

    before_save { self.email = email.downcase }
    before_create :create_activation_digest


    validates :name, presence: true, length: {maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    
    validates :email, presence: true, length: {maximum: 255}, format:{ with: VALID_EMAIL_REGEX},
    uniqueness: true
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

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
    def authenticated?(attribute, token)
        digest = self.send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end


    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest, User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
    end

    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    def password_reset_expired?
        reset_sent_at < 2.hours.ago 
    end

    # Activates an account.
    def activate
        update_attribute(:activated, true)
        update_attribute(:activated_at, Time.zone.now)
    end
    # Sends activation email.
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end

    def feed
        following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
        Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
    end

    def follow(other_user) #follow a user
        following << other_user
    end

    def unfollow(other_user)
        following.delete(other_user)
    end
    
    def following?(other_user) #check current user followed a user
        following.include?(other_user)
    end

    private
    def create_activation_digest
        self.activation_token = User.new_token
        self.activation_digest = User.digest(activation_token)
    end
end
