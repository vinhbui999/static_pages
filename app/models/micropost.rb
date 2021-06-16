class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :user_id, presence: true
  validates :content, presence: true, length:{maximum: 140}
  default_scope -> {order(create_at: :desc)}
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png], message:"Must be a valid image format"},
                    size: {less_than: 5.megabytes, message:"Should be less than 5MB"}


  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
