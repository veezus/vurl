# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def page_title
    @vurl && !@vurl.title.blank? ?  @vurl.title : "Veez's URL shortener"
  end
end
