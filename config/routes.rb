Rails.application.routes.draw do
  get "/set_env", to: "calendar#set_env"
  get "/calendar", to: "calendar#get_cal"
end
