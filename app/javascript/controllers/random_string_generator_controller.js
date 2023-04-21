import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["field"]

  generateRandomString(event) {
    event?.preventDefault();
    this.fieldTarget.value = Math.random().toString(36).toUpperCase().substr(2, 8)
  }
}
