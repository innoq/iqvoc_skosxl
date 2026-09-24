// Central export of iqvoc_skosxl's own JavaScript, for other apps/gems to
// import (via `import 'iqvoc_skosxl'`, resolved through package.json's
// "main"). Does not start Rails/UJS - see application.js for that.
import 'iqvoc'

import 'es6-promise/auto'

import './iqvoc_skosxl/new_label_modal'
import './iqvoc_skosxl/duplicate_check'
