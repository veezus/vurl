class VurlsController < ApplicationController
  # GET /vurls
  # GET /vurls.xml
  def index
    @vurls = Vurl.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vurls }
    end
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
    @vurl = Vurl.find(params[:id])
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
    @vurl = Vurl.find(params[:id])

    respond_to do |format|
      if @vurl.update_attributes(params[:vurl])
        flash[:notice] = 'Vurl was successfully updated.'
        format.html { redirect_to(@vurl) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vurl.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vurls/1
  # DELETE /vurls/1.xml
  def destroy
    @vurl = Vurl.find(params[:id])
    @vurl.destroy

    respond_to do |format|
      format.html { redirect_to(vurls_url) }
      format.xml  { head :ok }
    end
  end

  def redirect
    if vurl = Vurl.find_by_slug(params[:slug])
      redirect_to vurl.url
    else
      redirect_to new_vurl_path
    end
  end
end
