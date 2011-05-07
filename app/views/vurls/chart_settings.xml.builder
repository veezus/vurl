xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.settings do
  xml.type 'column'
  xml.data_type 'xml'
  xml.decimals_separator '.'
  xml.thousands_separator ','
  xml.digits_after_decimal 0
  xml.reload_data_interval 10

  xml.column do
    case current_period
    when 'hour'
      xml.width 90
    when 'day'
      xml.width 70
    when 'week'
      xml.width 40
    end
    xml.grow_time 0.5
    xml.balloon_text "<div align='center' style='text-align:center; color:#FFF'>{value} clicks<br />{series}</div>"
    xml.hover_brightness 30
  end

  xml.legend do
    xml.enabled false
  end

  xml.grid do
    xml.category do
      xml.alpha 0
    end
    xml.value do
      xml.alpha 0
    end
  end

  xml.values do
    xml.value do
      xml.min 0
      xml.integers_only 1
    end
    xml.category do
      case current_period
      when 'hour'
        xml.frequency 5
      when 'day'
        xml.frequency 3
      when 'week'
        xml.frequency 1
      end
    end
  end

  xml.plot_area do
    xml.margins do
      xml.left 30
      xml.right 30
      xml.top 40
      xml.bottom 20
    end
  end
end

