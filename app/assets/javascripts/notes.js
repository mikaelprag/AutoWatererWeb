$(function() {

  $('#notes-link').click(function (event) {
    $('.notes').slideToggle();
    event.preventDefault();
  });

});

function initNoteFormButtons() {

  $('#note-form-submit').click(function (event) {
    $('#new_note').submit();
    event.preventDefault();
  });

  $('#note-form-cancel').click(function (event) {
    $('#note-form').html('');
    event.preventDefault();
  });
}
