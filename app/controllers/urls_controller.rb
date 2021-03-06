class UrlsController < ApplicationController
  before_action :set_url, only: [:show, :edit, :update, :destroy]
  before_action :set_url_host

  # GET /urls
  # GET /urls.json
  def index    
    @urls = Url.all.order(hit_count: :desc)
  end

  # GET /urls/1
  # GET /urls/1.json
  def show
  end

  # GET /urls/new
  def new
    @url = Url.new
  end

  # GET /urls/1/edit
  def edit
  end

  # POST /urls
  # POST /urls.json
  def create
    @url = Url.new(url_params)
    
    set_url_host_model
    
    respond_to do |format|
      if @url.save
        format.html { redirect_to @url, notice: 'Url was successfully created.' }
        format.json { render :show, status: :created, location: @url }
      else
        format.html { render :new }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /urls/1
  # PATCH/PUT /urls/1.json
  def update
    
    set_url_host_model

    respond_to do |format|
      if @url.update(url_params)
        format.html { redirect_to @url, notice: 'Url was successfully updated.' }
        format.json { render :show, status: :ok, location: @url }
      else
        format.html { render :edit }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /urls/1
  # DELETE /urls/1.json
  def destroy
    @url.destroy
    respond_to do |format|
      format.html { redirect_to urls_url, notice: 'Url was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # handle for request of shorten url
  def redirect        
    url = Url.find_by(url_short: params[:path])
    if !url.present?
      flash[:ERROR] = "Shorten Url doesn't exist: #{@url_host}#{params[:path]}"
      redirect_to action: "index"
    else
      url.update(hit_count: url.hit_count + 1)
      redirect_to url["url_long"]
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      @url = Url.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def url_params
      params.require(:url).permit(:url_long, :url_short)
    end

    # AZ27062016: add address to model data, needed for warning message
    def set_url_host_model
      if @url.present?
        @url.url_host = @url_host
      end
    end    

    # AZ27062016: build address here, needs less requests than in the view
    def set_url_host      
      @url_host = request.protocol() + request.host_with_port() + '/'             
    end    
end
