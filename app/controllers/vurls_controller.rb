class VurlsController < ApplicationController
  # GET /vurls
  # GET /vurls.xml
  def index
    redirect_to new_vurl_path
  end

  # GET /vurls/1
  # GET /vurls/1.xml
  def show
    @vurl = Vurl.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vurl }
    end
  end

  # GET /vurls/new
  # GET /vurls/new.xml
  def new
    @vurl = Vurl.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vurl }
    end
  end

  # GET /vurls/1/edit
  def edit
    redirect_to new_vurl_path
  end

  # POST /vurls
  # POST /vurls.xml
  def create
    @vurl = Vurl.new(params[:vurl])

    respond_to do |format|
      if @vurl.save
        flash[:notice] = 'Vurl was successfully created.'
        format.html { redirect_to(@vurl) }
        format.xml  { render :xml => @vurl, :status => :created, :location => @vurl }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vurl.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vurls/1
  # PUT /vurls/1.xml
  def update
    redirect_to new_vurl_path
  end

  # DELETE /vurls/1
  # DELETE /vurls/1.xml
  def destroy
    redirect_to new_vurl_path
  end

  def redirect
    if vurl = Vurl.find_by_slug(params[:slug])
      click = Click.new(:vurl => vurl, :ip_address => request.env["REMOTE_ADDR"], :user_agent => request.user_agent)
      unless click.save
        logger.warn "Couldn't create Click for Vurl (#{vurl.inspect}) because it had the following errors: #{click.errors}"
      end
      redirect_to vurl.url
    else
      redirect_to new_vurl_path
    end
  end

  def preview
    redirect_to new_vurl_path unless @vurl = Vurl.find_by_slug(params[:slug])
  end

  def random
    redirect_to Vurl.random.url
  end
end
