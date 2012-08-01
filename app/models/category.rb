class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  field :resource_owner_id
  field :name

  attr_protected :resource_owner_id

  validates :name, presence: true
  validates :resource_owner_id, presence: true
end
