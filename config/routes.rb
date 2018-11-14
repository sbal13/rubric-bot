Rails.application.routes.draw do
  get "/oauth2callback", to: "calendar#set_env"
  get "/calendar", to: "calendar#get_cal"
end
