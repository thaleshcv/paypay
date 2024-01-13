import { Controller } from "@hotwired/stimulus";
import { Toast } from "bootstrap";
// Connects to data-controller="toast"
export default class extends Controller {
  connect() {
    const toasts = this.element.querySelectorAll(".toast");

    if (toasts.length) {
      toasts.forEach((item) => {
        Toast.getOrCreateInstance(item).show();
      });
    }
  }
}
