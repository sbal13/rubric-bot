class LectureReviewer < ApplicationRecord
  belongs_to :reviewer, class_name: "User"
  belongs_to :lecture
end
