class CreateLectures < ActiveRecord::Migration[5.2]
  def change
    create_table :lectures do |t|
      t.integer :lecturer_id
      t.string :cohort_name
      t.datetime :date
      t.string :title
      t.integer :class_id

      t.timestamps
    end
  end
end
