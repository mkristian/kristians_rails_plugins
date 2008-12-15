# Parsedate
module Parsedate
  
  def parsedate(ref, varname, default = nil)
    if ref.nil? or ref.size == 0
      nil
    else
      varname = varname.to_s
      date = "#{ref[varname + '(1i)']}-#{ref[varname + '(2i)']}-#{ref[varname + '(3i)']}"
      # test first if the whole thing is nil, i.e. all parts are nil
      if date == "--"
        nil
      else
        begin
          ref[varname] = Date.parse(date)
          ref.delete(varname + '(1i)')
          ref.delete(varname + '(2i)')
          ref.delete(varname + '(3i)')
          nil
        rescue ArgumentError => e
          ref[varname] = default.nil? ? Time.today : default
          "invalid #{varname}: #{date}"
        end
      end
    end
  end

  def parsetime(ref, varname, default = nil)
    if ref.nil? or ref.size == 0
      nil
    else
      varname = varname.to_s
      time = "#{ref[varname + '(1i)']}-#{ref[varname + '(2i)']}-#{ref[varname + '(3i)']} #{ref[varname + '(4i)']}:#{ref[varname + '(5i)']}]}"
      begin
        ref[varname] = DateTime.parse(time)
        ref.delete(varname + '(1i)')
        ref.delete(varname + '(2i)')
        ref.delete(varname + '(3i)')
        ref.delete(varname + '(4i)')
      ref.delete(varname + '(5i)')
        nil
      rescue ArgumentError => e
        ref[varname] = default.nil? ? Time.now : default
        "invalid #{varname}: #{time}"
      end
    end
  end

end
