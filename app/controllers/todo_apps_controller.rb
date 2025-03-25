class TodoAppsController < ApplicationController
    def index
        @todos=TodoApp.all
        render json: { tasks: @todos, message: "All tasks fetched successfully" }, status: 200
    end

    def create
        @todo=TodoApp.new(todo_details)
        if @todo.save
            render json: { task: @todo, message: "Task created successfully" }, status: 201
        else
            render json: { message: @todo.errors }, status: 400
        end
    end

    def show
        @todo=TodoApp.find(id: params[:id])
        render json: { task: @todo, message: "Task fetched successfully" }, status: 200
    rescue ActiveRecord::RecordNotFound
        render json: { message: "Task not found" }, status: 404
    end

    def update
        @todo=TodoApp.find(params[:id])
        if @todo.update(todo_details)
            render json: { task: @todo, message: "Task updated successfully" }, status: 200
        end
    rescue ActiveRecord::RecordNotFound
        render json: { message: "Task not found" }, status: 404
    end

    def destroy
        @todo = TodoApp.find(params[:id])
        @todo.destroy
        render json: { message: "Task deleted successfully" }, status: 200
    rescue ActiveRecord::RecordNotFound
        render json: { message: "Task not found" }, status: 404
    end

    private
    def todo_details
        params.permit(:title, :isCompleted, :priority)
    end
end
