import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "taskList", "title", "editForm", "input"]

  connect() {
    console.log("Search controller connected!")
  }

  edit() {
    console.log("hii")
    this.titleTarget.style.display = "none"; 
    this.editFormTarget.style.display = "block";
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
