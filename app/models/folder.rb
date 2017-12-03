class Folder
  include ActiveModel::Model
  attr_accessor :id, :name, :id_parent_folder, :full_path, :created_at, :created_by, :updated_at, :updated_by, :contents
  attr_reader :type

  def initialize(options)
    super(options)
    @type = 1
  end

  def root?
    id.nil?
  end


end