$(document).ready(function() {
  $(document).on('click', '.closeFlash', function() {
    $('.flash').slideUp(200);
    return false;
  });
});