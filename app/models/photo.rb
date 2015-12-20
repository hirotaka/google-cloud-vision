class Photo < ActiveRecord::Base
  mount_uploader :file, FileUploader
end
