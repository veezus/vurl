xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.chart do
  # xml.message "You can broadcast any message to chart from data XML file", :bg_color => "#FFFFFF", :text_color => "#000000"
  xml.series do
    @periods.each_with_index do |day, index|
      if @vurl.chart_with_hours?
        xml.value "#{day.month}/#{day.day} #{day.hour}:00", :xid => index
      else
        xml.value "#{day.month}/#{day.day}", :xid => index
      end
    end
  end

  xml.graphs do
   #the gid is used in the settings file to set different settings just for this graph
    xml.graph :gid => 'hits_by_day' do
      @periods.each_with_index do |period, index|
        hits = @vurl.clicks_in_period(period).size
        xml.value hits, :xid => index, :color => "#00688D", :gradient_fill_colors => "#00688D,#00688D", :description => 'Clicks'
      end
    end
  end
end
