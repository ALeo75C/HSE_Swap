class Faculty < ApplicationRecord
  has_many :minors
  belongs_to :city
end
