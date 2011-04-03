class String
  
  def truncate length
    if length > 0
      self.strip!
      if self.length > length
        out_array = []
        words = self.split(' ')
        for word in words
          if ((out_array + [word]).join(' ').length) < length
            out_array << word
          else
            break
          end
        end
        string_to_return = out_array.join(' ')
        
        # in case truncate is too short
        if string_to_return.length == 0
          string_to_return = self[0..length]
        end
      
        # remove any trailing spaces.
        string_to_return.strip! 
        
        # special last characters
        if string_to_return[-1,1] == '.'
          string_to_return += '..'
        elsif string_to_return[-1,1] == ','
          string_to_return.chop!
          string_to_return += '...'
        else  
          string_to_return += '...'
        end
        return string_to_return
      else
        return self
      end
    end
  end
  
  def remove_tags
    self.gsub(/<[^>]*>/,'')
  end
  
  
end