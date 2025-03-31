import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "taskList"]

  connect() {
    console.log("Search controller connected!")
  }

  fetchTasks() {
    const title = this.inputTarget.value.trim();
    
    // If input is empty, do nothing
    if (title === "") {
      this.taskListTarget.innerHTML = ""; // Clear results
      return;
    }

    // Fetch filtered tasks
    fetch("/get-tasks", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ title: title })
    })
      .then(response => response.json())
      .then(data => {
        this.taskListTarget.innerHTML = ""; // Clear previous results
        data.tasks.forEach(task => {
          this.taskListTarget.innerHTML += `<li>${task.title}</li>`;
        });
      })
      .catch(error => console.error("Error fetching tasks:", error));
  }
}
