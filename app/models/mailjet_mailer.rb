Mailjet.configure do |config|
	config.api_key = ENV["MAILJET_API_KEY"]
	config.secret_key = ENV["MAILJET_SECRET_KEY"]
	config.api_version = ENV["MAILJET_API_VERSION"]
end


class MailjetMailer 

	def self.send(reviewer, lecture)

		campus = nil
		course = nil

		if lecture.lecturer.name
			lecturer_name = lecture.lecturer.name
		else
			at_index = lecture.lecturer.email.index("@")

			lecturer_name = lecture.lecturer.email.slice(0, at_index)
											.gsub(".", " ")
											.titleize
		end

		lecturer_name_for_URL = lecturer_name.gsub(" ", "+")

		form_link = "https://docs.google.com/forms/d/e/1FAIpQLSeIxrWlJumSdU7p8PAEsLrjcOWMWPwkhskT8TyQcMjbM0XZsw/viewform?
		usp=pp_url"
		
		form_link += campus ? "&entry.1989695038=#{campus}" : ""
		form_link += course ? "&entry.1104039381=#{course}" : ""
		form_link += "&entry.1311120359=#{lecture.title}"
		form_link += "&entry.1414070469=#{lecturer_name_for_URL}"
		

		Mailjet::Send.create(messages: [{
		'From'=> {
				'Email'=> 'instructor.bot@flatironschool.com',
				'Name'=> 'Instructor Bot'
		},
		'To'=> [
				{
						'Email'=> reviewer.email,
						'Name'=> reviewer.name || reviewer.email
				}
		],
		'Subject'=> "Invitation to Review #{lecture.title} Lecture",
		'HTMLPart'=> "
			<body>
				<p>Hi #{reviewer.name || reviewer.email}, </p>

				<p>You have been requested to submit a review for the #{lecture.title} that was given on #{lecture.date}. Please use fill out the following Google Form: 
					<a href='#{form_link}'>Peer Observation Form</a>
				</p>
			</body>
		"
}]
)
		
	end
end