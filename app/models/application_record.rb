class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  before_validation :auto_populate_attributes

  def auto_populate_attributes;end
end
