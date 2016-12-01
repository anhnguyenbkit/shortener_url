require 'imgkit'

class ShortenersController < ApplicationController
  before_action :set_shortener, only: [:show, :edit, :update, :destroy]
  
  # GET /shorteners
  # GET /shorteners.json
  def index
    @shorteners = Shortener.all
  end

  # GET /shorteners/1
  # GET /shorteners/1.json
  def show
  end

  def show_link
    @shortener = Shortener.find_by short_url: params[:short_url]
    Shortener.update(@shortener.id, :num_click => (@shortener.num_click + 1))
    redirect_to @shortener.long_url
  end

  def new_release
    puts "--------------> debug new_release"
    respond_to do |format|
      format.html
      format.js
    end
  end

  def upload_image
    puts "---------------------> debug upload_image"
    kit   = IMGKit.new(@shortener.long_url, quality: 5, width: 400, height: 500, zoom: 0.4)
    puts "------------> step new"
    img   = kit.to_img(:png)
    puts "------------> step create img"
    file  = Tempfile.new(["template_#{@shortener.id}", 'png'], 'tmp',
                         :encoding => 'ascii-8bit')
    puts "------------> step create file"
    file.write(img)
    puts "------------> step write file"
    file.flush
    puts "------------> step flush file"
    @shortener.snapshot = file
    file.unlink
    puts "------------> step unlink"
    puts @shortener.errors.full_messages
end

  # GET /shorteners/new
  def new
    @shortener = Shortener.new
  end

  # GET /shorteners/1/edit
  def edit
  end

  # POST /shorteners
  # POST /shorteners.json
  def create
    @shortener = Shortener.new(shortener_params)
    @shorteners = Shortener.all
    # @shortener.snapshot = Tempfile.new(['hello', '.jpg'])
    # render js: "create.js.erb"
    upload_image
    puts @shortener.errors.full_messages
    respond_to do |format|
      if @shortener.save
        # Encode long URL to short URL
        @encode_url = bijective_encode
        # Update short URL to DB
        Shortener.update(@shortener.id, :short_url => @encode_url, :num_click => 0)
        # render a view
        format.json { head :no_content }
        format.js
        # upload_image
        # format.html { redirect_to shorteners_path, notice: 'Shortener was successfully created.' }
      else
        format.html { render :new }
        puts @shortener.errors.full_messages
        # format.json { render json: @shortener.errors, status: :unprocessable_entity }
      end
    end
    # upload_image
  end

  # PATCH/PUT /shorteners/1
  # PATCH/PUT /shorteners/1.json
  def update
    respond_to do |format|
      if @shortener.update(shortener_params)
        format.html { redirect_to @shortener, notice: 'Shortener was successfully updated.' }
        format.json { render :show, status: :ok, location: @shortener }
      else
        format.html { render :edit }
        format.json { render json: @shortener.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shorteners/1
  # DELETE /shorteners/1.json
  def destroy
    @shortener.destroy
    respond_to do |format|
      format.html { redirect_to shorteners_url, notice: 'Shortener was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shortener
      @shortener = Shortener.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shortener_params
      params.require(:shortener).permit(:title, :long_url, :short_url, :num_click, :snapshot)
    end
end
