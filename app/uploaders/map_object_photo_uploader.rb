# encoding: utf-8

class MapObjectPhotoUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/imgs"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  #resize_and_pad(width, height, background=:transparent, gravity=::Magick::CenterGravity) will pad the remaining area with the given color, which defaults to transparent (for gif and png, white for jpeg).
  #resize_to_fit                   The image may be shorter or narrower than specified
  #resize_to_fill(width, height)   If necessary, crop the image in the larger dimension.“
  #resize_to_limit(width, height)  Will only resize the image if it is larger than the specified dimensions. The resulting image may be shorter or narrower


  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fill => [236, 150]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
     %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
