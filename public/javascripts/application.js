$(document).ready(function() {
  set_focus_on_url_input();
  $("button.lucky_link").click(function() {
    document.location = $(this).attr('url');
    return false;
  });
  loadTweets();
  setInterval(loadTweets, 10000);
  setInterval(reloadScreenshots, 3000);
  setInterval(reloadTitle, 3000);
  setInterval(reloadDescription, 3000);
  setupCopyToClipboardPopup();
  $('li.member-thumb a.refresh').live('click', function() {
    $('a.screenshot').fancybox({'titleShow' : false});
    return false;
  });
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

function reloadScreenshots() {
  $('li.member-thumb a.refresh').each(function() {
    $(this).refreshContent('screenshot');
  });
}

function reloadTitle() {
  $('li.member-name a.refresh').each(function() {
    $(this).refreshContent('title');
  });
}

function reloadDescription() {
  $('li.member-info .refresh').each(function() {
    $(this).refreshContent('description');
  });
}

$.fn.refreshContent = function(action) {
  parentUl = $(this).parents('ul')[0];
  vurl_id = $(parentUl).attr('id').split('_')[1];
  url = "/vurls/" + vurl_id + "/" + action;
  $(this).parent().load(url);
}
