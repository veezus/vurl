$(document).ready(function($) {
  $('.lucky_link').simpletip({
    content: "Click to view a random vurl from the archives!",
    fixed: false
  });
  $('#vurl_url').focus();
  setup_clipboard();
});

function setup_clipboard() {
  ZeroClipboard.setMoviePath('http://localhost:3000/ZeroClipboard.swf');
  vurl_link = $('#vurlified_url');
  clip = new ZeroClipboard.Client();
  clip.glue('copy_to_clipboard');
  clip.setText(vurl_link.attr('href'));
}
