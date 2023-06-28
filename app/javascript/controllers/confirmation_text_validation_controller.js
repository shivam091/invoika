import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["confirmationText", "confirmButton"];
  static confirmationPattern;

  connect() {
    if (this.hasConfirmButtonTarget) {
      this.confirmButtonTarget.setAttribute("disabled", true);
    }
    if (this.hasConfirmationTextTarget) {
      this.confirmationPattern = new RegExp(this.confirmationTextTarget.dataset.pattern);
    }
  }

  validateConfirmationText(event) {
    event.preventDefault();
    if (this.hasConfirmButtonTarget) {
      if (this.confirmationPattern.test(event.target.value) === true) {
        this.confirmButtonTarget.removeAttribute("disabled");
      } else {
        this.confirmButtonTarget.setAttribute("disabled", true);
      }
    }
  }
}
