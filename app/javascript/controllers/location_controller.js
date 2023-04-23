import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {

  static targets = ["countrySelect", "stateSelect", "citySelect"]
  static values = {
    stateUrl: String,
    cityUrl: String,
  }

  connect() {
  }

  fetchStates(event) {
    event?.preventDefault();

    let params = new URLSearchParams();
    params.append("country_id", this.countrySelectTarget.selectedOptions[0].value);
    params.append("state_target", this.stateSelectTarget.id);
    params.append("city_target", this.citySelectTarget.id);

    get(this.stateUrlValue, {
      query: params,
      responseKind: "turbo-stream"
    })
  }

  fetchCities(event) {
    event?.preventDefault();

    let params = new URLSearchParams();
    params.append("state_id", this.stateSelectTarget.selectedOptions[0]?.value);
    params.append("city_target", this.citySelectTarget.id);

    get(this.cityUrlValue, {
      query: params,
      responseKind: "turbo-stream"
    });
  }
}
