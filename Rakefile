# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

desc "This task is called by the Heroku scheduler add-on"
task :send_daily_invitations => :environment do
    # calendar_lectures = CalendarInviter.get_data
    
    # calendar_lectures.each do |cohort_name, lectures|
    #   lectures.each do |lecture|
    #     lecture.lecture_reviewers.each do |lr|
    #       if !lr.sent_invitation 
    #         MailjetMailer.send(lr.reviewer, lecture)
    #         lr.update(sent_invitation: true)
    #       end
    #     end
    #   end
    # end

    RestClient.get("https://rubric-bot.herokuapp.com/calendar")
end


Rails.application.load_tasks
