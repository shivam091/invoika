import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {

  static targets = ["countrySelect", "stateSelect"]
  static values = {
    url: String,
    selected: String
  }

  connect() {
    this.fetchStates();
  }

  fetchStates(event) {
    event?.preventDefault();

    let params = new URLSearchParams();
    params.append("country_id", this.countrySelectTarget.selectedOptions[0].value);
    params.append("target", this.stateSelectTarget.id);
    params.append("selected", this.selectedValue);

    get(this.urlValue, {
      query: params,
      responseKind: "turbo-stream"
    });
  }
}
