desc "This task is called by the Heroku scheduler add-on"
task :send_daily_invitations => :environment do
  	calendar_lectures = CalendarInviter.get_data
		
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
end
