# require_relative "../services/new_todo_service"
class NewTodoAppController < ApplicationController
  include NewTodoAppService
  def home
    render json: { message: NewTodoAppService.message("Mohit") }
  end
end
