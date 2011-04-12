module HtmlHelper

  def remove_tags str
    return str.gsub(/<[^>]*>/,'')
  end

  def add_breaks str
    str.gsub(/$/,'<br>')
  end
  
  def error_messages_for(target)
    if target.errors.any?
      error_messages = target.errors.full_messages.uniq
      out = "<div class='error alert'>"
      out += "<h2>#{ pluralize(error_messages.count, "error") } prohibited this record from being saved:</h2>"
      out += "<ul>"
      error_messages.each do |msg|
        out += "<li>#{ msg }</li>"  
      end
      out += "</ul>"
      out += "</div>"
    end
  end

  DELIMITER = ' > '
  def breadcrumbs links
    out = '<div id="breadcrumbs">'
    delimiter = ''
    links.each {|link|
      out += delimiter + link
      delimiter = DELIMITER
    }
    out += "</div>"
    return out
  end
  
  def error(content, title = nil)
    out = alert(content, title, 'error')
    flash[:error] = nil
    return out
  end

  def confirmation(content, title = nil)
    out = alert(content, title, 'confirmation')
    flash[:confirmation] = nil
    return out
  end

  def notice(content, title = nil)
    out = alert(content, title, 'notice')
    flash[:notice] = nil
    return out
  end

  def alert(content, title = nil, class_name = '')
    out = ''
    if content.class == Array
      out = "<ul>"
      for error in content
        out += "<li>#{error}</li>"
      end
      out += "</ul>"
    else
      out = content
    end
    content = out
    unless content.nil? || content.blank?
      title = "<div class=\"#{class_name}_title\">#{title}</div>" if title
      out = "<div class=\"#{class_name} alert\" id=\"#{class_name}\">#{title}<div class=\"#{class_name}_content\">#{content}</div><div id='close' class='clickable' onclick='$$(\"div.alert\").each(Element.hide);'>OK</div></div>"
    end
    return out
  end

end

