
class CalendarController < ApplicationController
	def get_cal
		calendar_lectures = CalendarInviter.get_data

		if calendar_lectures.class == String

			# byebug
			redirect_to calendar_lectures
		else
			calendar_lectures.each do |cohort_name, lectures|
				lectures.each do |lecture|
					lecture.lecture_reviewers.each do |lr|
						if !lr.sent_invitation 
							MailjetMailer.send(lr.reviewer, lecture)
							lr.update(sent_invitation: true)
						end
					end
				end
			end

			render json: calendar_lectures
		end
		
	end

	def set_env
		token = params[:code]
		GoogleCalendar.set_credentials(token)

		redirect_to "/calendar"
	end


end