import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="submit"
export default class extends Controller {
  connect() {
    const { element } = this;

    element.addEventListener("change", function (evt) {
      element.requestSubmit();
    });
  }
}
