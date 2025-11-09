pin "application"
pin "@hotwired/turbo-rails", to: "@hotwired--turbo-rails.js" # @8.0.16
pin_all_from "app/javascript/controllers", under: "controllers"



pin "@hotwired/turbo", to: "@hotwired--turbo.js" # @8.0.13
pin "@rails/actioncable/src", to: "@rails--actioncable--src.js" # @8.0.201
pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"
