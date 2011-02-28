actions :run
attribute :download_path, :kind_of => String, :name_attribute => true
attribute :bucket, :kind_of => String, :required => true
attribute :s3_file_path, :kind_of => String, :required => true
