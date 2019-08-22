jQuery(document).ready(function() {
  var $labelInput = $('#label_value');
  var target = $labelInput.data('query-url');
  var uriTemplate = $labelInput.data('entity-uri');

  if (target && uriTemplate) {
    $labelInput.on('keyup', IQVOC.debounce(function() {
      var labelValue = this.value;

      queryLabels(target, labelValue).then(function(labels) {
        resetInput($labelInput);

        if (labels.length > 0) {
          setWarningState($labelInput);
          setFeedback($labelInput, labels, uriTemplate);
        }
      });
      }, 300)
    );
  }

  function queryLabels(target, value) {
    return new Promise(function(resolve, _reject) {
      if (value === '' || value.length < 3) {
        resolve([])
        return;
      };

      $.ajax({
        url: target,
        data: {
          query: value,
          mode: 'exact_match'
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
      return $('<li>').append(buildLabelLink(label, uriTemplate))
    });

    return ul.append(lis);
  }

  function buildLabelLink(label, uriTemplate) {
    var uri = uriTemplate.replace("%7Bid%7D", label.id);
    if (!label.published) {
      uri = uri.concat('?published=0');
    }

    labelLink = $('<a>', {
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
