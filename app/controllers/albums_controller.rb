class AlbumsController < ApplicationController
  # GET /albums
  # GET /albums.xml
  def index
    where_hash = {}
    where_hash[:label] = params[:label] if params[:label]
    where_hash[:band_id] = params[:band_id] if params[:band_id]
    
    @albums = Album.where(where_hash)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @albums }
    end
  end

  # GET /albums/1
  # GET /albums/1.xml
  def show
    @album = Album.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @album }
    end
  end

  # GET /albums/new
  # GET /albums/new.xml
  def new
    @album = Album.new
    if (params[:id])
      @album.band = Band.find(params[:id])
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @album }
    end
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
  end

  # POST /albums
  # POST /albums.xml
  def create
    new_band = params[:album][:band_id]
    this_venue = String.new
    
    if new_band.length > 0
      added_band = Band.new
      added_band = Band.find_by_id(new_band)
      this_band = added_band
      params[:album][:band] = this_band
    end
    
    if (params[:album][:image])
      params[:album][:image] = Album.save(params[:album])
      logger.info "set params[:album][:image] to #{params[:album][:image]}"
    end
    
    @album = Album.new(params[:album])

    respond_to do |format|
      if @album.save
        format.html { redirect_to(@album, :notice => 'Album was successfully created.') }
        format.xml  { render :xml => @album, :status => :created, :location => @album }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /albums/1
  # PUT /albums/1.xml
  def update
    @album = Album.find(params[:id])

    respond_to do |format|
      
      new_band = params[:album][:band_id]

      if new_band.length > 0
        added_band = Band.new
        added_band = Band.find_by_id(new_band)
        
        @album.band = added_band
        
      end
      params[:album][:band] = @album.band
      
      if (params[:album][:image])
        params[:album][:image] = Album.save(params[:album])
        logger.info "set params[:album][:image] to #{params[:album][:image]}"
      end
      
      if @album.update_attributes(params[:album])
        format.html { redirect_to(@album, :notice => 'Album was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.xml
  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to(albums_url) }
      format.xml  { head :ok }
    end
  end
end
