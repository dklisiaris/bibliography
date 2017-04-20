module EmailHelper
  def email_image_tag(image, **options)
    image_path = Rails.root.join("app/assets/images/#{image}")
    image_name = image_path.basename.to_s
    attachments[image_name] = File.read(image_path)
    image_tag attachments[image_name].url, **options
  end

  def email_uploaded_image_tag(image, **options)
    image_path = image.try(:file).try(:path)
    image_basename = File.basename(image_path)

    image_version = image_basename.split('_').first.to_s if image_basename
    attachement_key = image.model.imageable_type +
      image.model.id.to_s +
      image_version +
      File.extname(image_basename)

    attachments[attachement_key] = File.read(image_path)
    image_tag attachments[attachement_key].url, **options
  end
end
