class PropertySerializer < ApplicationSerializer
  cached true

  attributes :uri, :id, :name, :type, :default, :suggested, :range, :created_at, :updated_at

  def uri
    PropertyDecorator.decorate(property).uri
  end

  def include_range?
    range
  end
end
