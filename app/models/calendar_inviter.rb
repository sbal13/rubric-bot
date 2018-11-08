class CalendarInviter
		def self.get_data
			calendar_events = GoogleCalendar.get_calendars

			if calendar_events.class == String
				return calendar_events
			end
			
			calendar_lectures = {}
			calendar_events.each do |calendar_name, events|

				lectures = events.map do  |event|
					creator_email = event.creator.email

					creator = User.find_or_create_by(email: creator_email)

					lecture = Lecture.find_or_create_by(
							lecturer: creator,
							date: event.start.date_time,
							title: event.summary,
							cohort_name: calendar_name
						)
					if event.attendees
						self.parse_attendees(event, lecture)
					end

					lecture
				end

				calendar_lectures[calendar_name] = lectures
			end

			calendar_lectures
		end

		def self.parse_attendees(event_data, lecture)
			emails = event_data.attendees.map { |attendee| attendee.email}

			emails.each do |email|
				potential_reviewer = User.find_or_create_by(email: email)
				if (lecture.lecturer != potential_reviewer && !lecture.reviewers.include?(potential_reviewer))

					lecture.reviewers << potential_reviewer
				end
			end
		end 
end