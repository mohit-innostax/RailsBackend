class TodoAppsController < ApplicationController
    include NewTodoAppService
    skip_before_action :verify_authenticity_token, only: [ :new_index, :create, :new_form, :update, :destroy, :register, :login ]
    before_action :authorize_request, except: [ :login, :register ]
    def index
        # @todo=NewTodoAppService.get_tasks()
        if current_user.id == 7
            @todo=TodoApp.all
        else
            @todo = TodoApp.where(createdby: current_user.id)
        end
        puts @todo
      #   render json: { tasks: @todos, message: "All tasks fetched successfully" }, status: 200
    end

    def new_index
        data = JSON.parse(request.body.read)  # Parse JSON request body
        title = data["title"]                 # Extract title from JSON

        if title.present?
            @tasks=TodoApp.where("title ILIKE ? AND createdby = ? ", "%#{title}%", current_user.id)
        else
            @tasks=TodoApp.all
        end

    render json: @tasks
    end

    def create
        result=NewTodoAppService.create_task(todo_details)
        puts "Current params>>>>:#{todo_details.inspect}"
        if result[:success]
            AutoCompleteTaskJob.set(wait: 15.seconds).perform_later(result[:task])
            redirect_to "/get-tasks", notice: "Task created successfully"
        else
            render :new_form
        end
    end

    def show
        id=params[:id]
        @todos=TodoApp.find(id)
        render json: { task: @todo, message: "Task fetched successfully" }, status: 200
    rescue ActiveRecord::RecordNotFound
        render json: { message: "Task not found" }, status: 404
    end

    def update
        @todo_apps=TodoApp.find(params[:id])
        authorize @todo_apps
        data = JSON.parse(request.body.read)
        title = data["title"]
        result=NewTodoAppService.update_task(params[:id], title)
        if result[:success]
            render json: { task: { id: params[:id], title: title }, message: "Task edited successfully" }, status: 200
        else
            render json: { message: result[:error] }, status: result[:status]
        end
    end

    def destroy
        @todo_apps=TodoApp.find(params[:id])
        authorize @todo_apps
        result=NewTodoAppService.delete_task(params[:id])
        if result[:success]
            render json: { message: result[:message] }, status: result[:status]
        else
            render json: { message: result[:message] }, status: result[:status]
        end
    end

    private
    def todo_details
        params.permit(:title, :isCompleted, :priority, :createdby)
    end
end
