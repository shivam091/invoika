import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  connect() {
    this.toggleRecurringCycle();
  }

  toggleRecurringCycle(event) {
    event?.preventDefault();
    if (this.element.checked) {
      document.querySelector("#invoice_recurring_cycle").removeAttributes("readonly", "disabled");
      document.querySelector("#recurring_cycle_period").style.display = "block";
    } else {
      document.querySelector("#invoice_recurring_cycle").setAttributes({"readonly": "readonly", "disabled": "disabled"});
      document.querySelector("#recurring_cycle_period").style.display = "none";
    }
  }
}
