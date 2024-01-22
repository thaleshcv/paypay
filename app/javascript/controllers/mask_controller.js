import { Controller } from "@hotwired/stimulus";
import currencyMask from "./masks/currencyMask";

// Connects to data-controller="mask"
export default class extends Controller {
  static targets = ["currency"];

  setupCurrencyMask(el) {
    el.value = currencyMask(el.value);
    el.addEventListener("input", function (evt) {
      el.value = currencyMask(evt.target.value);
    });
  }

  initialize() {
    this.setupCurrencyMask = this.setupCurrencyMask.bind(this);
  }

  connect() {
    this.currencyTargets.forEach(this.setupCurrencyMask);
  }
}
