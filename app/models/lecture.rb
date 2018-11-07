class Lecture < ApplicationRecord
  belongs_to :lecturer, class_name: "User"
  # belongs_to :class
  has_many :lecture_reviewers
  has_many :reviewers, through: :lecture_reviewers, class_name: "User"
end
