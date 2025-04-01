import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "taskList", "title", "editForm", "input", "search", "form"]

  connect() {
    console.log("Search controller connected!")
  }

  edit() {
    console.log("hii")
    this.titleTarget.style.display = "none"; 
    this.editFormTarget.style.display = "block";
    const taskId = this.element.id.replace("todo_", "");
    console.log(taskId)
  }

  cancelEdit() {
    this.titleTarget.style.display = "block"; 
    this.editFormTarget.style.display = "none"; 
  }

  update(event) {
    event.preventDefault();
    const taskId = this.element.id.replace("todo_", "");
    const newTitle = this.inputTarget.value;

    fetch(`/update-task/${taskId}`, {
      method: "PUT",
      body: JSON.stringify({ title: newTitle }),
    })
    .then(response => response.json())
    .then(data => {
      if (data.task) {
        this.titleTarget.textContent = data.task.title; 
        this.cancelEdit();
      }
    });
  }

  delete(event) {
    console.log("hi")
    event.preventDefault();
    const taskId = this.element.id.replace("todo_", "");
    fetch(`/delete-task/${taskId}`, {
      method: "DELETE",
    })
    .then(response => response.json())
    .then(data => {
      if (data.message) {
        console.log(data.message);
      }
      this.element.remove();
    })
    .catch(error => console.log("Error while deleting",error));
  }

  submit(event){
    
    if (event.key === "Enter") {
      console.log("enter in submit")
      event.preventDefault();  
      this.formTarget.submit(); 
    }
  }

  fetchTasks() {
    const title = this.inputTarget.value.trim();
    
    // If input is empty, do nothing
    if (title === "") {
      this.taskListTarget.innerHTML = ""; // Clear results
      return;
    }

    // Fetch filtered tasks
    fetch("/get-tasksss", {
      method: "POST",
      body: JSON.stringify({ title: title })
    })
      .then(response => response.json())
      .then(data => {
        this.taskListTarget.innerHTML = ""; // Clear previous results
        data.map(task => {
          this.taskListTarget.innerHTML += `<li class="task-name">${task.title}</li>`;
        });
      })
      .catch(error => console.error("Error fetching tasks:", error));
  }


}
