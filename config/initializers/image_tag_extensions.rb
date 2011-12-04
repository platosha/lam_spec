module ActionView
  module Helpers
    module AssetTagHelper
      def image_tag_with_title(source, options = {})
        options[:alt] ||= ''
        image_tag_without_title(source, options[:alt].blank? ? options : options.merge(:title => options[:title] || options[:alt]))
      end

      alias_method_chain :image_tag, :title
    end
  end
end