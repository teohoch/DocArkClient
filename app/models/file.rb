class File
  include ActiveModel::Model
  attr_reader :id, :name, :id_parent_folder, :full_path, :created_at,
              :created_by, :updated_at, :updated_by, :type, :access_url,
              :expiration_date, :version, :type, :available_versions

  def initialize(options)
    super(options)
    @type = 1
    @available_versions = get_available_versions
  end

  def root?
    id.nil?
  end

  private

  def get_available_versions
    temp = []
    version.times do |index|
      temp.append(index)
    end
  end


end