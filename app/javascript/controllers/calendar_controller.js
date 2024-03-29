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

    const [currentDateYear, currentDateMonth, _] = currentDateValue
      .split("-")
      .map((i) => parseInt(i));

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
          theme: "light",
          themeDetect: true,
          today: false
        },
        selected: {
          dates: [currentDateValue],
          month: currentDateMonth - 1,
          year: currentDateYear
        }
      }
    });

    this.calendar.init();
  }
}
