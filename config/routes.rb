Rails.application.routes.draw do
  get "/scripts", to: "calendar#scripts"
  get "/calendar", to: "calendar#get_cal"
end
