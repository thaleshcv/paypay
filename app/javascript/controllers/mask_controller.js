import { Controller } from "@hotwired/stimulus";

function setupCurrencyMask(element) {}

// Connects to data-controller="mask"
export default class extends Controller {
  static targets = ["currency"];
  connect() {
    this.currencyTargets.forEach(setupCurrencyMask);
  }
}
