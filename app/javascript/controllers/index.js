// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

eagerLoadControllersFrom("controllers", application)

import { NavbarController } from "librum-components/controllers/navbar_controller"

application.register('librum-components-navbar', NavbarController)
