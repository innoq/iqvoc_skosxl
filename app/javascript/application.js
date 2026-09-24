// Entry point for the esbuild build script in package.json - this is what
// Propshaft actually serves for iqvoc_skosxl's own standalone use. Other
// gems importing 'iqvoc_skosxl' (resolved via package.json's "main") get
// ./manifest instead - the same content minus starting Rails/UJS, which is
// an app-bootstrapping concern that only the final consuming app should
// trigger.
import Rails from '@rails/ujs'
Rails.start()

import './manifest'
