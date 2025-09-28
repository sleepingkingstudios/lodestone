// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

eagerLoadControllersFrom("controllers", application)

import { ConfirmFormController } from "librum-components/controllers/confirm-form-controller"
import { NavbarController } from "librum-components/controllers/navbar-controller"

application.register('librum-components-confirm-form', ConfirmFormController)
application.register('librum-components-navbar', NavbarController)
