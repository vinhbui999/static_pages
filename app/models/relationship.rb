class Relationship < ApplicationRecord
    belongs_to :follower, class_name: "User" #return follower
    belongs_to :followed, class_name: "User" #return followed
end
