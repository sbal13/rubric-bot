require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/redis_token_store'
require 'fileutils'

OOB_URI = 'https://rubric-bot.herokuapp.com'.freeze
APPLICATION_NAME = 'Google Calendar API Ruby Quickstart'.freeze
TOKEN_PATH = 'token.yaml'.freeze
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

class GoogleCalendar
	def self.authorize
		client_id = Google::Auth::ClientId.new(ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"])
		token_store = Google::Auth::Stores::RedisTokenStore.new(redis: Redis.new)
		authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
		user_id = 'default'
		credentials = authorizer.get_credentials(user_id)
		if credentials.nil?
			url = authorizer.get_authorization_url(base_url: OOB_URI)
			return url
		end

		credentials
	end

	def self.set_credentials(code)
		client_id = Google::Auth::ClientId.new(ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"])
		token_store = Google::Auth::Stores::RedisTokenStore.new(redis: Redis.new)
		authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
		user_id = 'default'
		credentials = authorizer.get_credentials(user_id)

		if credentials.nil?
			credentials = authorizer.get_and_store_credentials_from_code(
				user_id: user_id, code: code, base_url: OOB_URI
			)
		end
		credentials
	end

	def self.get_calendars
		service = Google::Apis::CalendarV3::CalendarService.new
		service.client_options.application_name = APPLICATION_NAME
		creds = self.authorize

		if creds.class == String
			return creds
		else
			service.authorization = self.authorize
		end

		calendars = service.list_calendar_lists

		selected_calendars = []
		calendars.items.each do |calendar|
			if (calendar.id.include?("group.calendar.google.com") && calendar.summary.downcase.include?("web-"))
				selected = {id: calendar.id, name: calendar.summary.downcase}
				selected_calendars << selected
			end
		end

		calendars_and_events = {}
		selected_calendars.each do |calendar_data|
			calendars_and_events[calendar_data[:name]] = self.get_events(calendar_data, service)
		end

		calendars_and_events
	end



	def self.get_events(calendar_data, service)
		response = service.list_events(calendar_data[:id],
																	 max_results: 30,
																	 single_events: true,
																	 order_by: 'startTime',
																	 time_min: Time.now.iso8601,
																	 time_max: (Time.now + (60 * 60 * 24)).iso8601)
		lectures = response.items.select do |event|
			event.summary.downcase.include?("lecture")
		end

		return lectures
	end
end

