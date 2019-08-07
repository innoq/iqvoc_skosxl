jQuery(document).ready(function() {
  $('#label_value').on('keyup', IQVOC.debounce(function() {
    $this = $(this);
    var target = $this.data('query-url');
    var labelValue = this.value;

    queryLabels(target, labelValue).then(function(labels) {
      resetInput($this);

      if (labels.length > 0) {
        setWarningState($this);
        setFeedback($this, labels);
      }
    });
    }, 300)
  );

  function queryLabels(target, value) {
    return new Promise(function(resolve, _reject) {
      if (value === '' || value.length < 3) {
        resolve([])
        return;
      };

      $.ajax({
        url: target,
        data: {
          query: value
        }
      })
      .done(function(response) {
        console.log('response: ', response);
        resolve(response);
      })
      .fail(function() {
        resolve([]); // return empty result on failure
      })
    });
  }

  function setWarningState($valueInput) {
    var formGroup = $valueInput.closest('.form-group');
    $(formGroup).addClass('has-warning');
  }

  function setFeedback($valueInput, labels) {
    var duplicates = buildLabelList($valueInput, labels);
    var message = $valueInput.data('duplicate-message');
    var feedback = $('<span class="help-block"></span>')
      .text(message)
      .append(duplicates);

    $valueInput.after(feedback);
  }

  function buildLabelList($valueInput, labels) {
    var ul = $('<ul class="list-inline"></ul>')
    var lis =  labels.map(function(label) {
      var uriTemplate = $valueInput.data('data-entity-uri');
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
    $(formGroup).removeClass('has-warning');
    $(formGroup).find('.help-block').remove();
  }
});
