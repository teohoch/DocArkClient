class ApiConsumer
  include RestClient
  attr_reader :base_url, :token, :client, :valid, :resourse_url


  def initialize(base_url, token, app_id, app_secret)
    @base_url = base_url
    @client = OAuth2::Client.new(app_id, app_secret, site: base_url)
    @token = OAuth2::AccessToken.from_hash(@client,token)
    if @token.expired?
      begin
        @token = @token.refresh!
        @valid = true
      rescue RuntimeError
        @valid = false
      end
    end
  end

  def valid?
    valid
  end

  private

  def get(id: nil, query_params: {})
    temp = generate_url(id,query_params)
    begin
      RestClient.get(temp.to_s, Authorization: "Bearer #{token.token}")
    rescue RestClient::ExceptionWithResponse => e
      e.response
    rescue RestClient::ServerBrokeConnection => e
      e.response
    end
  end

  def post(id: nil, query_params: {}, body: {}, format: :json)
    temp = generate_url(id,query_params)
    begin
      RestClient.post(temp.to_s, body, Authorization: "Bearer #{token.token}", Content_type: format)
    rescue RestClient::ExceptionWithResponse => e
      e.response
    rescue RestClient::ServerBrokeConnection => e
      e.response
    end
  end

  def patch(id: nil, query_params: {}, body: {}, format: :json)
    temp = generate_url(id,query_params)
    begin
      RestClient.patch(temp.to_s, body, Authorization: "Bearer #{token.token}", Content_type: format)
    rescue RestClient::ExceptionWithResponse => e
      e.response
    rescue RestClient::ServerBrokeConnection => e
      e.response
    end
  end

  def put(id: nil, query_params: {}, body: {})
    temp = generate_url(id,query_params)
    begin
      RestClient.post(temp.to_s, body, Authorization: "Bearer #{token.token}", multipart: true )
    rescue RestClient::ExceptionWithResponse => e
      e.response
    rescue RestClient::ServerBrokeConnection => e
      e.response
    end
  end

  def delete(id: nil, query_params: {})
    temp = generate_url(id,query_params)
    begin
      RestClient.delete(temp.to_s,headers={Authorization: "Bearer #{token.token}"})
    rescue RestClient::ExceptionWithResponse => e
      e.response
    rescue RestClient::ServerBrokeConnection => e
      e.response
    end

  end

  def generate_url(id=nil,query_params={})
    temp = if id.nil?
      resourse_url.dup
    else
      URI.join(resourse_url.to_s, id.to_s.to_s)
           end
    temp_queries = []
    query_params.each do |key, value|
      temp_queries.append([key,value])
    end
    temp.query = URI.encode_www_form(temp_queries)
    temp
  end

end