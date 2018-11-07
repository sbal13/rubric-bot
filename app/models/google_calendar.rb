require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'



OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
APPLICATION_NAME = 'Google Calendar API Ruby Quickstart'.freeze
CREDENTIALS_PATH = 'credentials.json'.freeze
TOKEN_PATH = 'token.yaml'.freeze
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

class GoogleCalendar
##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
  def self.authorize
    client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: OOB_URI)
      puts 'Open the following URL in the browser and enter the ' \
           "resulting code after authorization:\n" + url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI
      )
    end
    credentials
  end

  def self.get_calendars
    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = self.authorize

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
    puts 'Upcoming events:'
    puts 'No upcoming events found' if response.items.empty?
    
    lectures = response.items.select do |event|
      event.summary.downcase.include?("lecture")
    end

    return lectures
  end
end

