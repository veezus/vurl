# Allow paperclip to generate filenames based on our vurl slugs
Paperclip.interpolates :slug do |attachment, style|
  attachment.instance.slug
end
