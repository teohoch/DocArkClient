class FoldersController < ApplicationController
  before_action :authorize
  before_action :set_folder_consumer
  before_action :set_document_consumer, only: [:show, :index]
  after_action :update_current_session


  # GET /folders
  # GET /folders.json
  def index
    # base_url, token, app_id, app_secret
    temp = @folder_client.index({id_parent_folder: -1})
    @contents = temp[:data]
    temp2 = @document_client.index(id_parent_folder: -1)
    @contents = @contents + temp2[:data]
    @current_folder = Folder.new({name: 'Root'})
    @success = temp[:status] and temp2[:status]

  end

  # GET /folders/1
  # GET /folders/1.json
  def show
    temp = @folder_client.index(id_parent_folder: get_id)
    @contents = temp[:data]
    temp2 = @folder_client.find(get_id)
    @folder = temp2[:data]
    temp3 = @document_client.index(id_parent_folder: get_id)
    @contents = @contents + temp3[:data]
    @success = temp[:status] and temp2[:status] and temp3[:status]
  end

  # GET /folders/new
  def new
    @folder = Folder.new(:id_parent_folder => (get_id_parent == '-1' ? nil : get_id_parent ))
    @fixed = (not get_id_parent.nil?)
    if @fixed
      if get_id_parent == '-1'
        temp = {status: true, response: 'Not Required'}
      else
        temp = @folder_client.find(id: get_id_parent)
        if temp[:status]
          @collection = [temp[:data]]
        end
      end
    else
      temp = @folder_client.index
      if temp[:status]
        @collection = temp[:data]
      end
    end
    @success = temp[:status]
  end

  # GET /folders/1/edit
  def edit
    temp = @folder_client.find(get_id)
    @folder = temp[:data]
    @fixed = false

    temp2 = @folder_client.index
    if temp2[:status]
      @collection = temp2[:data]
    end

    @success = temp[:status] and temp2[:status]
  end

  # POST /folders
  # POST /folders.json
  def create
    temp = @folder_client.create(params_create_folder)
    if temp[:status]
      flash_message(:notice,"#{t('folder.folder')} #{t('succesfully_created')}")
      folder_path(temp[:data].id)
    else
      flash_message(:error, 'Problema creando Carpeta')
      redirect_to root_path
    end
    @success = temp[:status]
  end

  # PATCH/PUT /folders/1
  # PATCH/PUT /folders/1.json
  def update
    temp = @folder_client.update(get_id, params_create_folder)
    if temp[:status]
      flash_message(:notice,"#{t('folder.folder')} #{t('succesfully_updated')}")
      redirect_to folder_path(temp[:data].id)
    else
      flash_message(:error, 'Problema actualizando Carpeta')
      redirect_to root_path
    end
    @success = temp[:status]
  end

  # DELETE /folders/1
  # DELETE /folders/1.json
  def destroy
    temp = @folder_client.destroy(get_id, force)
    if temp[:status]
      flash_message(:notice,"#{t('folder.folder')} #{t('succesfully_destroyed')}")
      redirect_to folders_path
    else
      if temp[:code] == 403
        @id = get_id
        @message = temp[:response]['message']
      else
        flash_message(:error, temp[:response]['message'])
        redirect_to root_path
      end

    end
    @success = temp[:status]
  end

  private

  def set_folder_consumer
    @folder_client = FolderConsumer.new(@current_session[:url], @current_session[:access_token], @current_session[:app_id], @current_session[:app_secret])
    @current_session[:access_token] = @folder_client.token.to_hash
  end

  def set_document_consumer
    @document_client = DocumentConsumer.new(@current_session[:url], @current_session[:access_token], @current_session[:app_id], @current_session[:app_secret])
    @current_session[:access_token] = @document_client.token.to_hash
  end

  def update_current_session
    session[:current_session] = @current_session.to_json(:include => :access_token)
  end

  def get_id
    if params.has_key? :id
      params[:id]
    else
      flash_message(:error, t('error.provide_id'))
      redirect_to root_path
    end
  end

  def get_id_parent
    if params.has_key? :id_parent_folder and not params[:id_parent_folder].blank?
      params[:id_parent_folder]
    else
      nil
    end
  end

  def force
    ((params.has_key? :force and params[:force] == '1' )? 1 : 0)
  end

  def params_create_folder
    temp = params.require(:folder).permit(:name, :id_parent_folder)
    unless temp.has_key? :name and temp.has_key? :id_parent_folder
      flash_message(:error, t('error.provide_create_parameters'))
      redirect_to root_path
    end
    temp
  end

end
