class Screenshot
  PATH_TO_EXECUTABLE = "/usr/local/bin/wkhtmltoimage"

  attr_accessor :options, :tempfile

  def initialize(options={})
    options.assert_valid_keys :vurl
    self.options = options
  end

  def snap!
    Rails.logger.debug "Taking screenshot by executing #{command}"
    tempfile.write `#{command}`
    tempfile
  end

  def command
    "#{PATH_TO_EXECUTABLE} #{command_options} #{vurl.url} -"
  end

  def command_options
    "-f png --quality 70 --javascript-delay 1000 --crop-w 1024 --crop-h 768"
  end

  def method_missing(method, *args)
    if options.has_key?(method)
      options[method]
    else
      super(method, *args)
    end
  end

  private

  def tempfile
    @tempfile ||= Tempfile.new('vurl-screenshot')
  end
end
