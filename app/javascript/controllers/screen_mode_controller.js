import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["icon"];
  static classes = ["hidden"];

  initialize() {
    this.toggleScreenMode = this.toggleScreenMode.bind(this);
  }

  connect() {
    this.fullScreenMode = (!window.screenTop && !window.screenY);
  }

  toggleScreenMode(event) {
    event.preventDefault();

    if (this.fullScreenMode) {
      document.exitFullscreen();
    } else {
      document.body.requestFullscreen();
    }
    this.fullScreenMode = !this.fullScreenMode;
    this.iconTargets.forEach(icon => icon.classList.toggle(this.hiddenClass));
  }
}
