
$(document).ready(function() {
  $('.datetime').each(function() {
    var times = $(this).text().replace(/^\s+|\s+$/, '').split(/\s+/);
    $(this).text(times[1]);
  });
});

