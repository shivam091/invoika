import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["isRecurred", "recurringCycleField", "recurredTillField"]

  connect() {
    this.toggleRecurringFields();
  }

  toggleRecurringFields(event) {
    event?.preventDefault();
    if (this.isRecurredTarget.checked) {
      this.recurringCycleFieldTarget.removeAttributes("readonly", "disabled");
      this.recurredTillFieldTarget.removeAttributes("readonly", "disabled");
      this.recurringCycleFieldTarget.focus();
    } else {
      this.recurringCycleFieldTarget.value = "";
      this.recurredTillFieldTarget.value = "";
      this.recurringCycleFieldTarget.setAttributes({"readonly": "readonly", "disabled": "disabled"});
      this.recurredTillFieldTarget.setAttributes({"readonly": "readonly", "disabled": "disabled"});
    }
  }
}
