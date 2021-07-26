jQuery(document).ready(function($) {
  $(".new-label-modal").click(function(ev) {
    ev.preventDefault();

    var modal = $("#label-in-concept-modal");
    var target = $(this).attr("href");
    $('.navbar-fixed-bottom').hide()

    $.get(target, function(data) {
      modal.html(data);
      modal.modal();
    });
  });

  $('#label-in-concept-modal').on('hidden.bs.modal', function () {
    $('.navbar-fixed-bottom').show();
  });

});
