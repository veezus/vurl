class VurlsController < ApplicationController

  expose(:current_vurls) { current_user.vurls }
  expose(:new_vurl) do
    vurl_params = (params[:vurl] || {}).reverse_merge!(:url => params[:url])
    Vurl.new vurl_params
  end
  expose(:recent_popular_vurls) { Vurl.popular_since current_period_ago, :limit => 8 }
  expose(:most_popular_vurls) { Vurl.most_popular.not_spam }

  skip_before_filter :verify_authenticity_token, :only => :create
  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => current_vurl }
    end
  end

  def real_time_clicks
    respond_to do |format|
      format.html { render :nothing => true }
      format.xml
    end
  end

  def screenshot
    render :partial => 'screenshot', :locals => {:vurl => current_vurl}
  end

  def stats
    if current_vurl.nil?
      render :template => 'vurls/not_found' and return
    end
    respond_to do |format|
      format.html { render :show }
      format.xml  { render :xml => current_vurl }
    end
  end

  def preview
    redirect_to :action => :stats, :slug => params[:slug]
  end

  def new
    respond_to do |format|
      format.html
      format.xml  { render :xml => new_vurl }
    end
  end

  def edit
    redirect_to new_vurl_path
  end

  def api
    new_vurl.ip_address = request.remote_ip
    new_vurl.user = User.create!(:name => 'API')

    respond_to do |format|
      if suspected_spam_user?
        format.html { render :text => "Get thee behind me, spammer" and return }
        format.json { render :json => {:errors => "Get thee behind me, spammer"} and return }
      end

      if new_vurl.save
        format.html { render :text => redirect_url(new_vurl.slug) }
        format.json { render :json => {:shortUrl => redirect_url(new_vurl.slug)} }
      else
        format.html { render :text => new_vurl.errors.full_messages }
        format.json { render :json => {:errors => new_vurl.errors.full_messages.first} }
      end
    end
  end

  def create
    new_vurl.ip_address = request.remote_ip
    new_vurl.user = current_user

    if suspected_spam_user?
      flash[:error] = "We've flagged this IP for suspicious activity and will not allow creation of Vurls.  Contact Veezus if you feel this is an error"
      redirect_to root_path and return
    end

    respond_to do |format|
      if new_vurl.save
        flash[:notice] = 'Vurl was successfully created.'
        format.html { redirect_to stats_path(new_vurl.slug) }
        format.xml  { render :xml => new_vurl, :status => :created, :location => new_vurl }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => new_vurl.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    redirect_to new_vurl_path
  end

  # DELETE /vurls/1
  # DELETE /vurls/1.xml
  def destroy
    redirect_to new_vurl_path
  end

  def redirect
    if current_vurl
      click = Click.new(:vurl => current_vurl, :ip_address => request.env["REMOTE_ADDR"], :user_agent => request.user_agent, :referer => request.referer)
      unless click.save
        logger.warn "Couldn't create Click for Vurl (#{current_vurl.inspect}) because it had the following errors: #{click.errors}"
      end
      redirect_to current_vurl.url
    else
      render :template => 'vurls/not_found'
    end
  end

  def random
    redirect_to Vurl.random.url
  end

  protected

  def current_period
    return params[:period] if params[:period]
    if action_name == 'stats'
      'hour'
    else
      'week'
    end
  end

  def current_period_ago
    period_ago current_period
  end
  helper_method :current_period_ago

  def period_ago period
    1.send(period).ago
  end
  helper_method :period_ago

end
