class Topic < ActiveRecord::Base
  validates :title, presence: true, length: {minimum: 5}
  validates :author, presence: true, length: {minimum: 3}
end