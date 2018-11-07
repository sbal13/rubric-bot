class User < ApplicationRecord
  has_many :given_lectures, class_name: "Lecture", foreign_key: "lecturer_id"
  has_many :lecture_reviewers, foreign_key: "reviewer_id"
  has_many :reviewed_lectures, class_name: "Lecture", through: :lecture_reviewers
end
