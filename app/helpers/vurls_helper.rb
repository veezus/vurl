module VurlsHelper
  def summary_for vurl
    content = " On #{vurl.created_at.to_date.to_s(:long)} you created a vurl for #{link_to vurl.title, vurl.url} which has received a total of #{vurl.clicks_count} clicks. "
    if vurl.last_click
      content += "The last click was received #{time_ago_in_words vurl.last_click.created_at} ago. "
    end
    content += "[#{link_to 'View stats', stats_path(vurl.slug)}] "
    content += "[#{link_to 'Vurl to link', redirect_url(vurl.slug)}] "
    content += clippy(redirect_url(vurl.slug))
    content_tag :li, content
  end
end
