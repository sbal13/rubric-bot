
class CalendarController < ApplicationController
	def get_cal
		calendar_lectures = CalendarInviter.get_data

		if calendar_lectures.class == String
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
		token = params[:token]
		GoogleCalendar.set_credentials(token)

		redirect_to "/calendar"
	end

	# def scripts

	#   response = GoogleScripts.fetch

	#   render json: response
	# end
end


# https://us19.api.mailchimp.com/3.0/
# f68c53b355eb4c64bef0c6749b52774f-us19