units = @vurl.units_for_last(@period)
xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.chart do
  xml.values do
    xml.value do
      xml.min 0
      xml.integers_only 1
    end
    xml.category do
      case @period
      when 'hour'
        xml.frequency 10
      when 'day'
        xml.frequency 3
      when 'week'
        xml.frequency 1
      end
    end
  end
  xml.series do
    units.each_with_index do |unit, index|
      case @period
      when 'hour'
        xml.value "#{unit.hour.to_s.rjust(2, '0')}:#{unit.min.to_s.rjust(2, '0')}", :xid => index
      when 'day'
        xml.value "#{unit.hour.to_s.rjust(2, '0')}:00", :xid => index
      when 'week'
        xml.value "#{Date::DAYNAMES[unit.day]}", :xid => index
      end
    end
  end

  xml.graphs do
   #the gid is used in the settings file to set different settings just for this graph
    xml.graph :gid => 'hits_by_day' do
      clicks = @vurl.clicks_for_last @period
      case @period
      when 'hour'
        units.each_with_index do |unit, index|
          clicks_for_this_minute = clicks[unit.min.to_s]
          hits = clicks_for_this_minute ? clicks_for_this_minute.size : 0
          xml.value hits, :xid => index, :color => "#00688D", :gradient_fill_colors => "#00688D,#00688D", :description => 'Clicks'
        end
      when 'day'
        units.each_with_index do |unit, index|
          clicks_for_this_hour = clicks[unit.hour.to_s]
          hits = clicks_for_this_hour ? clicks_for_this_hour.size : 0
          xml.value hits, :xid => index, :color => "#00688D", :gradient_fill_colors => "#00688D,#00688D", :description => 'Clicks'
        end
      when 'week'
        units.each_with_index do |unit, index|
          clicks_for_this_day = clicks[unit.day.to_s]
          hits = clicks_for_this_day ? clicks_for_this_day.size : 0
          xml.value hits, :xid => index, :color => "#00688D", :gradient_fill_colors => "#00688D,#00688D", :description => 'Clicks'
        end
      end
    end
  end
end
