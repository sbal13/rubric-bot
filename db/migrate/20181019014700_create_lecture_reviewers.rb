class CreateLectureReviewers < ActiveRecord::Migration[5.2]
	def change
		create_table :lecture_reviewers do |t|
			t.integer :reviewer_id
			t.integer :lecture_id
			t.boolean :reviewed
			t.boolean :sent_invitation

			t.timestamps
		end
	end
end
