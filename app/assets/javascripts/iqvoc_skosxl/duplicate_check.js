jQuery(document).ready(function($) {
  var $labelInput = $('#label_value');
  var target = $labelInput.data('query-url');
  var uriTemplate = $labelInput.data('entity-uri');
  var mode = $labelInput.data('duplicate-check-mode')

  if (target && uriTemplate) {
    $labelInput.on('input', IQVOC.debounce(function() {
      var labelValue = this.value.trim();

      queryLabels(target, labelValue, mode).then(function(labels) {
        resetInput($labelInput);

        if (labels.length > 0) {
          setWarningState($labelInput);
          setFeedback($labelInput, labels, uriTemplate);
        }
      });
      }, 300)
    );
  }

  function queryLabels(target, value, mode) {
    return new Promise(function(resolve, _reject) {
      if (value === '' || value.length < 3) {
        resolve([])
        return;
      }

      $.ajax({
        url: target,
        data: {
          query: value,
          mode: searchMode(mode),
        }
      })
      .done(function(response) {
        resolve(response);
      })
      .fail(function() {
        resolve([]); // return empty result on failure
      })
    });
  }

  function searchMode(mode) {
    const MODES = ['begins', 'exact_match', 'contains']
    if (MODES.includes(mode)) {
      return mode
    } else {
      return 'contains'
    }
  }

  function setWarningState($valueInput) {
    var formGroup = $valueInput.closest('.form-group');
    $(formGroup).addClass('has-warning has-feedback');

    var warningSign = $('<span id="duplicate-warning" class="glyphicon glyphicon-warning-sign form-control-feedback" aria-hidden="true">')
    $valueInput.after(warningSign);
  }

  function setFeedback($valueInput, labels, uriTemplate) {
    var duplicates = buildLabelList($valueInput, labels, uriTemplate);
    var message = $valueInput.data('duplicate-message');
    var feedback = $('<span class="help-block"></span>')
      .text(message)
      .append(duplicates);

    $valueInput.after(feedback);
  }

  function buildLabelList($valueInput, labels, uriTemplate) {
    var ul = $('<ul class="list-inline"></ul>')
    var lis =  labels.map(function(label) {
      return $('<li class="list-inline-item mr-1">').append(buildLabelLink(label, uriTemplate))
    });

    return ul.append(lis);
  }

  function buildLabelLink(label, uriTemplate) {
    var uri = uriTemplate.replace("%7Bid%7D", label.id);
    if (!label.published) {
      uri = uri.concat('?published=0');
    }

    var labelLink = $('<a>', {
      class: "badge badge-secondary",
      text: label.name,
      href: uri
    });
    return labelLink;
  }

  function resetInput($valueInput) {
    var formGroup = $valueInput.closest('.form-group');;
    $(formGroup).removeClass('has-warning has-feedback');

    // remove sign and message from dom
    $(formGroup).find('.help-block').remove();
    $(formGroup).find('#duplicate-warning').remove();
  }
});
