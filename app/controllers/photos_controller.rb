class PhotosController < ApplicationController
  permits :file, :detection_type

  def new
    @photo = Photo.new
  end

  def upload(photo, detection_type)
    @photo = Photo.new(photo)
    @detection_type = detection_type
    @result = GoogleCloudVision.new(@photo.file.path, detection_type).request
  end
end
