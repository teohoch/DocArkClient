class DocumentConsumer < ApiConsumer
  def initialize(base_url, token, app_id, app_secret)
    super(base_url, token, app_id, app_secret)
    @resourse_url = URI.join(@base_url, '/api/v1/files/')
  end

  def index(options={})
    response = get(query_params: options.slice(:name,
                                               :id_parent_folder, :limit=, :offset))
    success = false
    data = []
    if response.code == 200
      JSON.parse(response.body).each do |document|
        data.append(Document.new(document))
      end
      success = true
    end
    { response: JSON.parse(response.body), status: success,
      data: data, request: response.request}
  end

  def find(id)
    response = get(id)
    success = false
    data = nil
    if response.code == 200
      data = Folder.new(JSON.parse(response.body))
      success = true
    end
    { response: JSON.parse(response.body), status: success,
      data: data, request: response.request}
  end

  def create(body = {})
    response = post(body: body.to_json)
    success = false
    data = nil
    if response.code == 200
      data = Document.new(JSON.parse(response.body))
      success = true
    end
    { response: JSON.parse(response.body), status: success,
      data: data, request: response.request}
  end

  def update(id, body)
    response = patch(id: id, body: body.to_json)
    success = false
    data = nil
    if response.code == 200
      data = Document.new(JSON.parse(response.body))
      success = true
    end
    { response: JSON.parse(response.body), status: success,
      data: data, request: response.request}
  end
end