require_relative "../config/environment.rb"

calendar_lectures = CalendarInviter.get_data
    
calendar_lectures.each do |cohort_name, lectures|
  lectures.each do |lecture|
    lecture.reviewers.each do |reviewer|
      MailjetMailer.send(reviewer, lecture)
    end
  end
end

date = Date.new.to_s
exec("touch /Users/stevenbalasta/Development/Work/FeedbackBot/test_calendar/logs/#{date}.log")
