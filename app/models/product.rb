class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :description, presence: true
  validates :description, length: { in: 2..1000 }

  belongs_to :supplier
  # def supplier
  #   # Look in the supplier's table for a supplier with an id that matches supplier_id
  #   Supplier.find_by(id: supplier_id)
  # end

  has_many :images
  # def images
  #   Image.where(product_id: id)
  # end

  has_many :carted_products
  has_many :orders, through: :carted_products

  has_many :category_products
  has_many :categories, through: :category_products

  scope :title_search, ->(search_terms) do
          if search_terms
            where("name ILIKE ?", "%#{search_terms}%")
          end
        end

  scope :discounted, ->(check_discount) do
          if check_discount
            where("price < ?", 10)
          end
        end

  scope :sorted, ->(sort, sort_order) do
          if sort == "price" && sort_order == "asc"
            order(price: :asc)
          elsif sort == "price" && sort_order == "desc"
            order(price: :desc)
          else
            order(id: :asc)
          end
        end

  def is_discounted?
    price <= 10
  end

  def tax
    price * 0.09
  end

  def total
    price + tax
  end
end
