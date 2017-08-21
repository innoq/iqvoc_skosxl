jQuery(document).ready(function() {
  $(".new-label-modal").click(function(ev) {
    ev.preventDefault();

    var modal = $("#concept-teaser-modal");
    var target = $(this).attr("href");
    $('.navbar-fixed-bottom').hide()

    $.get(target, function(data) {
      modal.html(data);
      modal.modal();
    });
  });

  $('#concept-teaser-modal').on('hidden.bs.modal', function () {
    $('.navbar-fixed-bottom').show();
  });

});
