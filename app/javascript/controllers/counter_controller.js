import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="counter"
export default class extends Controller {
  static targets = ["count"]
  connect() {
    this.count = 0;  // Initialize counter
    this.updateCounters(); // Set initial values
  }

  increment() {
    this.count++;
    this.updateCounters(); // Update all targets
  }

  updateCounters() {
    this.countTargets.forEach(target => {
      target.textContent = this.count;  // Update each counter
    });
  }
}
