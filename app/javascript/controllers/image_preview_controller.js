import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["output"];

  initialize() {
    this.readURL = this.readURL.bind(this);
  }

  connect() {
  }

  readURL(event) {
    if (event.target.files && event.target.files[0]) {
      var reader = new FileReader();

      reader.onload = (event) => {
        this.outputTarget.src = event.currentTarget.result;
      }

      reader.readAsDataURL(event.target.files[0]);
    }
  }
}
