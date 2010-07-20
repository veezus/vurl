class TakeScreenshot
  @queue = :take_screenshot

  def self.perform(vurl_id)
    vurl = Vurl.find_by_id(vurl_id)
    vurl && vurl.take_screenshot!
  end
end
