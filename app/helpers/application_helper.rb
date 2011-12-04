# encoding: UTF-8
module ApplicationHelper  
  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer)
    self.output_buffer = render(:file => "layouts/#{layout}")
  end
  
  def title
    path = ["#{controller_name}.#{action_name}", "#{controller_name}.index", "default"].find{|path| I18n.backend.send(:lookup, I18n.locale, path, 'titles')}
    I18n.t(path, :scope => 'titles', :title => action_name == 'show' && controller.respond_to?(:resource) && controller.send(:resource).respond_to?(:title) && controller.send(:resource).title)
  end

  def meta
    @meta ||= {
      'og:site_name'   => t('titles.default'),
      'og:description' => t('titles.description'),
      'og:title'       => title,
      'og:type'        => 'article',
      'og:url'         => request.url,
      'og:image'       => image_path('og_logo_lookatme.png'),
      'fb:admins'      => "820344652,1307812797,717237210,1032121312"
    }
  end
  
  def paperclip_image(image, *args)
    options = args.extract_options!.reverse_merge(:autosize => true)
    style   = args.first || image.default_style
    
    if options.delete(:autosize) && !options[:size] && image.instance.send("#{image.name}?")
      size = image.image_size(style)
      options[:size] = "#{size[:width]}x#{size[:height]}"
    end
    
    options[:size] ||= options.delete(:default_size)
    
    image_tag(image.url(style), options)
  end
  
  def classes(*args)
    options = args.extract_options!
    args = options.inject(args){|memo, (k, v)| args << k if v; args}.compact.uniq
    args.any? ? args.join(" ") : nil
  end
end