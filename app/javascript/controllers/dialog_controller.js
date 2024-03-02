import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="dialog"
export default class extends Controller {
  static targets = ["dialog"];

  launchDialog() {
    this.dialogTarget.showModal();
  }

  closeDialog() {
    this.dialogTarget.close();
  }

  connect() {}
}
