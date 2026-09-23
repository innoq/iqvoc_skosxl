import * as bootstrap from 'bootstrap'

jQuery(document).ready(function($) {
  $(".new-label-modal").click(function(ev) {
    ev.preventDefault();

    var modal = $("#label-in-concept-modal");
    var target = $(this).attr("href");

    $.get(target, function(data) {
      modal.html(data);
      bootstrap.Modal.getOrCreateInstance(modal[0]).show();
    });
  });

});
