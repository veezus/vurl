$(document).ready(function() {
  set_focus_on_url_input();
  $("button.lucky_link").click(function() {
    document.location = $(this).attr('url');
    return false;
  });
  loadTweets();
  setInterval(loadTweets, 20000);
});

function set_focus_on_url_input() {
  $('#vurl_url').focus();
}

function loadTweets() {
  $("#vurlme_tweets").fadeOut();
  $("#vurlme_tweets").empty();
  $("#vurlme_tweets").tweet({
    query: "vurl.me OR vurlme",
    avatar_size: 48,
    count: 15,
    loading_text: "Searching twitter..."
  });
  $("#vurlme_tweets").fadeIn();
}
