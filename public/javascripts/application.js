$(document).ready(function() {
  setup_lucky_tooltip();
  setup_bookmarklet_tooltip();
  set_focus_on_url_input();
  setup_clipboard();
});

function set_focus_on_url_input() {
  $('#vurl_url').focus();
}

function setup_bookmarklet_tooltip() {
  $('.bookmarklet_help').simpletip({
    content: "Drag the 'Vurlify!' link to your toolbar to vurlify any page address while you're browsing",
    fixed: false
  });
}

function setup_clipboard() {
  ZeroClipboard.setMoviePath('http://localhost:3000/ZeroClipboard.swf');
  vurl_link = $('#vurlified_url');
  clip = new ZeroClipboard.Client();
  clip.glue('copy_to_clipboard');
  clip.setText(vurl_link.attr('href'));
}

function setup_lucky_tooltip() {
  $('.lucky_link').simpletip({
    content: "Click to view a random vurl from the archives!",
    fixed: false
  });
}
