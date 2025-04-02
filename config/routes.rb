Rails.application.routes.draw do
  post "/register", to: "auth#register"
  post "/login", to: "auth#login"
  post "/create-task", to: "todo_apps#create"
  get "/get-tasks", to: "todo_apps#index"
  post "/get-tasksss", to: "todo_apps#new_index"
  get "/get-task/:id", to: "todo_apps#show"
  get "/get-task", to: "todo_apps#show"
  put "/update-task/:id", to: "todo_apps#update"
  delete "/delete-task/:id", to: "todo_apps#destroy"
  get "/new-task", to: "todo_apps#new_form"
  get "/new-user", to: "todo_apps#register"
  get "/old-user", to: "todo_apps#login"
end
