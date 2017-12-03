class FolderConsumer < ApiConsumer
  def initialize(base_url, token, app_id, app_secret)
    super(base_url, token, app_id, app_secret)
    @resourse_url = URI.join(@base_url, '/api/v1/folders/')
  end

  def index(options={})
    response = get(query_params: options.slice(:name, :id_parent_folder, :limit=, :offset))
    success = false
    data = []
    if response.code == 200
      JSON.parse(response.body).each do |folder|
        data.append(Folder.new(folder))
      end
      success = true
    end
    {response: JSON.parse(response.body), status: success, data: data}
  end

  def find(id)
    response = get(id)
    success = false
    data = nil
    if response.code == 200
      Folder.new(JSON.parse(response.body))
      success = true
    end
    {response: JSON.parse(response.body), status: success, data: data}
  end
end