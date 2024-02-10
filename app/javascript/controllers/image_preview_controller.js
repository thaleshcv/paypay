import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="image-preview"
export default class extends Controller {
  static targets = ["image", "input"];

  handleInputChange(evt) {
    const { files } = evt.target;

    if (!files || files.length === 0) {
      return false;
    }

    this.dirtyImage = true;

    const selectedFile = files[0];

    const reader = new FileReader();
    reader.readAsDataURL(selectedFile);

    const self = this;
    reader.onloadend = function () {
      self.imageTarget.src = reader.result;
    };
  }

  restore() {
    this.inputTarget.value = "";
    this.imageTarget.src = this.originalImageTargetContent;
    this.dirtyImage = false;
  }

  connect() {
    this.dirtyImage = false;
    this.originalImageTargetContent = this.imageTarget.src;

    this.inputTarget.addEventListener(
      "change",
      this.handleInputChange.bind(this)
    );
  }
}
