# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@rails/request.js", to: "https://ga.jspm.io/npm:@rails/request.js@0.0.8/src/index.js"
pin "popper", to: "popper.js", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "moment", to: "https://ga.jspm.io/npm:moment@2.29.4/moment.js"
pin "moment-timezone", to: "https://ga.jspm.io/npm:moment-timezone@0.5.43/index.js"

pin_all_from "app/javascript/invoika", under: "invoika"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "application", preload: true
