Rails.application.routes.draw do
  post "/create-task", to: "todo_apps#create"
  get "/get-tasks", to: "todo_apps#index"
  get "/get-task/:id", to: "todo_apps#show"
  get "/get-task", to: "todo_apps#show"
  put "/update-task/:id", to: "todo_apps#update"
  delete "/delete-task/:id", to: "todo_apps#destroy"
end
