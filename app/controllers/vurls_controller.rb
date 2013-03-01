class VurlsController < ApplicationController
  expose(:current_vurl) do
    if slug = params[:slug]
      slug = slug[/^\w+/]
      Vurl.find_by_slug(slug)
    else
      Vurl.find_by_id(params[:id])
    end
  end

  def redirect
    if current_vurl
      click = Click.new(vurl: current_vurl, ip_address: request.env["REMOTE_ADDR"], user_agent: request.user_agent, referer: request.referer)
      unless click.save
        logger.warn "Couldn't create Click for Vurl (#{current_vurl.inspect}) because it had the following errors: #{click.errors}"
      end
      redirect_to safe_url_for(current_vurl), status: :moved_permanently
    else
      redirect_to '/'
    end
  end

  def safe_url_for(vurl)
    vurl.flagged_as_spam? ? spam_url(slug: vurl.slug) : vurl.url
  end
end
