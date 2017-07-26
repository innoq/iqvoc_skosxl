jQuery(document).ready(function() {
  $(".new-label-modal").click(function(e) {
    e.preventDefault;

    var modal = $("#newLabelModal");
    var target = $(this).attr("href");

    $.get(target, function(data) {
      modal.find('.modal-body').html(data);
      modal.modal();
    });

  });
});
