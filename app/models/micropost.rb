class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum:140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png], message: "Debe ser un formato de imagen valido", size: { less_than: 5.megabytes, message: "Debe ser menor a 5 MB."}}
  # Retorna una imagen reajustada para su visualización
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
