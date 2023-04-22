Element.prototype.removeAttributes = function(...attrs) {
  attrs.forEach(attr => this.removeAttribute(attr));
}

Element.prototype.setAttributes = function(attrs) {
  Object.keys(attrs).forEach(key => this.setAttribute(key, attrs[key]));
}
