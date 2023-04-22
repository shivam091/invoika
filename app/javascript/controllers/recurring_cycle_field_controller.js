import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["isRecurred", "recurringCycle", "recurringCycleWrapper"]

  connect() {
    this.toggleRecurringCycle();
  }

  toggleRecurringCycle(event) {
    event?.preventDefault();
    if (this.isRecurredTarget.checked) {
      this.recurringCycleTarget.removeAttributes("readonly", "disabled");
      this.recurringCycleWrapperTarget.style.display = "block";
      this.recurringCycleTarget.focus();
    } else {
      this.recurringCycleWrapperTarget.style.display = "none";
      this.recurringCycleTarget.value = "";
      this.recurringCycleTarget.setAttributes({"readonly": "readonly", "disabled": "disabled"});
    }
  }
}
