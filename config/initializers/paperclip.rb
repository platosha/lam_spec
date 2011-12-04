module Paperclip
  class Attachment
    def image_size(style = default_style)
      if File.exists?(path(style))
        File.open(path(style), "rb") do |f|
          size = ImageSize.new(f)
          {:width => size.width, :height => size.height}
        end
      end
    end
  end
  
  module ClassMethods
    def validates_presence_of_attachment(name, options = {})
      validate proc{|r| r.errors.add(name, :blank) unless send("#{name}?")}, options
    end
  end
end