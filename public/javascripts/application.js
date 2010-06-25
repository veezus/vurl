$(document).ready(function() {
  set_focus_on_url_input();
  $("button.lucky_link").click(function() {
    document.location = $(this).attr('url');
    return false;
  });
  loadTweets();
  setInterval(loadTweets, 10000);
  setupCopyToClipboardPopup();
});

function set_focus_on_url_input() {
  $('#vurl_url').focus();
}

function loadTweets() {
  $('#tweet_spinner').show();
  var latestTweetId = $("#vurlme_tweets").children(".tweet").attr("id");
  var url = "/twitter"
  if (latestTweetId)
    url += "?tweet_id=" + latestTweetId.split('_').pop();
  $.get(url, function(data) {
    $("#vurlme_tweets").prepend(data);
    $("#vurlme_tweets .new_tweet").each(function() {
      $(this).slideDown();
    });
  });
  $(".new_tweet").each(function() {
    $(this).removeClass('new_tweet');
  });
  $('#tweet_spinner').hide();
}

function setupCopyToClipboardPopup() {
  $(".clippy").tipsy({gravity: 'w', fallback: 'copy to clipboard'});
}
