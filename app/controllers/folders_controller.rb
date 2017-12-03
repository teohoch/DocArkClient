class FoldersController < ApplicationController
  before_action :authorize
  before_action :set_folder_consumer
  before_action :set_document_consumer, only: [:show, :index]


  # GET /folders
  # GET /folders.json
  def index
    # base_url, token, app_id, app_secret
    temp = @folder_client.index({id_parent_folder: -1})
    @contents = temp[:data]
    temp2 = @document_client.index(id_parent_folder: -1)
    @contents = @contents + temp2[:data]
    @current_folder = Folder.new({name: 'Root'})

  end

  # GET /folders/1
  # GET /folders/1.json
  def show
    temp = @folder_client.index(id_parent_folder: params[:id])
    @contents = temp[:data]
    temp2 = @folder_client.find(id: params[:id])
    @folder = temp2[:data]
    temp3 = @document_client.index(id_parent_folder: params[:id])
    @contents = @contents + temp3[:data]
  end

  # GET /folders/new
  def new
    @folder = Folder.new(:parent_folder_id => (folder_new_params) )
    @fixed = params.has_key? :parent_folder_id
  end

  # GET /folders/1/edit
  def edit
  end

  # POST /folders
  # POST /folders.json
  def create
    @folder = Folder.new(name: folder_params[:name], parent_folder_id: folder_create_params, created_by: current_user, updated_by: current_user)

    respond_to do |format|
      if @folder.save
        format.html { redirect_to @folder, notice: "#{Folder.model_name.human} #{t('succesfully_created')}" }
        format.json { render :show, status: :created, location: @folder }
      else
        format.html { render :new }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /folders/1
  # PATCH/PUT /folders/1.json
  def update
    respond_to do |format|
      if @folder.update(folder_params)
        format.html { redirect_to @folder, notice: "#{Folder.model_name.human} #{t('succesfully_updated')}" }
        format.json { render :show, status: :ok, location: @folder }
      else
        format.html { render :edit }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /folders/1
  # DELETE /folders/1.json
  def destroy
    @folder.destroy
    respond_to do |format|
      format.html { redirect_to folders_url, notice: "#{Folder.model_name.human} #{t('succesfully_destroyed')}" }
      format.json { head :no_content }
    end
  end

  private

  def set_folder_consumer
    @folder_client = FolderConsumer.new(@current_session[:url], @current_session[:access_token], @current_session[:app_id], @current_session[:app_secret])
  end

  def set_document_consumer
    @document_client = DocumentConsumer.new(@current_session[:url], @current_session[:access_token], @current_session[:app_id], @current_session[:app_secret])
  end

end
