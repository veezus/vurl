xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.chart do
  # xml.message "You can broadcast any message to chart from data XML file", :bg_color => "#FFFFFF", :text_color => "#000000"
  xml.series do
    @vurl.last_sixty_minutes.each_with_index do |day, index|
      xml.value "#{day.hour.to_s.rjust(2, '0')}:#{day.min.to_s.rjust(2, '0')}", :xid => index
    end
  end

  xml.graphs do
   #the gid is used in the settings file to set different settings just for this graph
    xml.graph :gid => 'hits_by_day' do
      @vurl.last_sixty_minutes.each_with_index do |minute, index|
        hits = @vurl.clicks.by_minute(minute).size
        xml.value hits, :xid => index, :color => "#00688D", :gradient_fill_colors => "#00688D,#00688D", :description => 'Clicks'
      end
    end
  end
end
