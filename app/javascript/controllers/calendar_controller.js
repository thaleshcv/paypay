import { Controller } from "@hotwired/stimulus";
import VanillaCalendar from "vanilla-calendar-pro";

// Connects to data-controller="calendar"
export default class extends Controller {
  static targets = ["input", "container"];

  connect() {
    const self = this;
    let currentDateValue = this.inputTarget.value;
    if (!currentDateValue) {
      currentDateValue = new Date().toISOString().split("T")[0];
    }

    this.calendar = new VanillaCalendar(this.containerTarget, {
      actions: {
        clickDay(_event, calendar) {
          self.inputTarget.value = calendar.selectedDates[0];
        }
      },
      settings: {
        iso8601: false,
        lang: "pt-BR",
        visibility: {
          themeDetect: false,
          today: false
        },
        selected: {
          dates: [currentDateValue]
        }
      }
    });

    this.calendar.init();
  }
}
