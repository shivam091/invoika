import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["discount", "discountType"]

  connect() {
    this.toggleDiscountField();
  }

  toggleDiscountField(event) {
    event?.preventDefault();
    if (this.discountTypeTarget.value) {
      this.discountTarget.removeAttributes("readonly", "disabled");
      if (!this.discountTarget.value) {
        this.discountTarget.focus();
      }
    } else {
      this.discountTarget.value = "";
      this.discountTarget.setAttributes({"readonly": "readonly", "disabled": "disabled"});
    }
  }
}
