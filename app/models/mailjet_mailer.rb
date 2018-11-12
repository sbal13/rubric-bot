Mailjet.configure do |config|
  config.api_key = ENV["MAILJET_API_KEY"]
  config.secret_key = ENV["MAILJET_SECRET_KEY"]
  config.api_version = ENV["MAILJET_API_VERSION"]
end


class MailjetMailer 

  def self.send(reviewer, lecture)

    campus = nil
    course = nil

    lecturer_name = lecture.lecturer.name || lecture.lecturer.name_from_email
    lecturer_name_for_URL = lecturer_name.gsub(" ", "+")

    reviewer_name = reviewer.name || reviewer.name_from_email

    form_link = "https://docs.google.com/forms/d/e/1FAIpQLSeIxrWlJumSdU7p8PAEsLrjcOWMWPwkhskT8TyQcMjbM0XZsw/viewform?
    usp=pp_url"
    
    form_link += campus ? "&entry.1989695038=#{campus}" : ""
    form_link += course ? "&entry.1104039381=#{course}" : ""
    form_link += "&entry.1311120359=#{lecture.title}"
    form_link += "&entry.1414070469=#{lecturer_name_for_URL}"
    
    email_body = "
    You have been requested to submit a review for the #{lecture.title} lecture that was given on #{lecture.date.strftime("%m/%d/%Y")}. Please use fill out the following Google Form:"

    Mailjet::Send.create(messages: [{
    'From'=> {
        'Email'=> 'instructor.bot@flatironschool.com',
        'Name'=> 'Instructor Bot'
    },
    'To'=> [
        {
            'Email'=> reviewer.email,
            'Name'=> reviewer_name
        }
    ],
    'Subject'=> "Invitation to Review #{lecture.title} Lecture",
    'HTMLPart'=> "
      <body>
        <p>Hi #{reviewer_name}, </p>

        <p> #{email_body}
          <a href='#{form_link}'>Peer Observation Form</a>
        </p>
      </body>
    "
}]
)
    
  end
end