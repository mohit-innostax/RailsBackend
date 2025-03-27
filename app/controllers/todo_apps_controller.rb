class TodoAppsController < ApplicationController
    include NewTodoAppService
    before_action :authorize_request
    def index
        @todos=NewTodoAppService.get_tasks()
        render json: { tasks: @todos, message: "All tasks fetched successfully" }, status: 200
    end

    def create
        result=NewTodoAppService.create_task(todo_details)
        if result[:success]
            render json: { task: result[:task], message: "Task created successfully" }, status: 201
        else
            render json: { message: result[:error] }, status: 400
        end
    end

    def show
        id=params[:id]
        @todo=TodoApp.find(id)
        render json: { task: @todo, message: "Task fetched successfully" }, status: 200
    rescue ActiveRecord::RecordNotFound
        render json: { message: "Task not found" }, status: 404
    end

    def update
        result=NewTodoAppService.update_task(params[:id], todo_details)
        if result[:success]
            render json: { task: result[:task], message: "Task created successfully" }, status: 201
        else
            render json: { message: result[:error] }, status: result[:status]
        end
    end

    def destroy
        result=NewTodoAppService.delete_task(params[:id])
        if result[:success]
            render json: { message: "Task deleted successfully" }, status: 200
        else
            render json: { message: result[:message] }, status: result[:status]
        end
    end

    private
    def todo_details
        params.permit(:title, :isCompleted, :priority)
    end
end
