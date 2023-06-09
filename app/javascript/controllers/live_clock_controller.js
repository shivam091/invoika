import { Controller } from "@hotwired/stimulus";
import moment from "moment-timezone";

export default class extends Controller {

  static targets = ["date", "time"];
  static values = {
    userTimeZone: String
  }

  initialize() {
    this.updateClock = this.updateClock.bind(this);
  }

  connect() {
    setInterval(() => {
      this.updateClock();
    }, 1000);
  }

  updateClock() {
    var $momentObject = moment().tz(this.userTimeZoneValue);
    this.dateTarget.innerHTML = $momentObject.format("ddd, MMMM D, YYYY")
    this.timeTarget.innerHTML = $momentObject.format("HH:mm:ss")
  }
}
