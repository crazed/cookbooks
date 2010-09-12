#GPL 2.0  http://www.gnu.org/licenses/gpl-2.0.html
#Zabbix CLI Tool and associated files
#Copyright (C) 2009,2010 Andrew Nelson nelsonab(at)red-tux(dot)net
#
#This program is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#as published by the Free Software Foundation; either version 2
#of the License, or (at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program; if not, write to the Free Software
#Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

##########################################
# Subversion information
# $Id: zdebug.rb 195 2010-07-19 06:39:59Z nelsonab $
# $Revision: 195 $
##########################################

module ZDebug

  # Either set_debug_level or set_facility_debug_level must be called before
  # the debug functions can be used.
  def set_debug_level(level)   # sets the current debug level for printing messages
    @@debug_level=level

    # Create faciltiy_level if it's not created already
    @@facility_level= {} if !defined?(@@facility_level)
  end

  # facility is a symbol, level is an integer
  def set_facility_debug_level(facility,level)
    # Create faciltiy_level if it's not created already
    @@facility_level= {} if !defined?(@@facility_level)

    @@facility_level[facility]=level
    
    # Create debug level if it's not already created
    @@debug_level=0 if !defined?(@@debug_level)
  end

  def debug_level
    @@debug_level
  end

  # level - level to show message (Integer)
  # variable - variable to show (Object)
  # message - message to be prepended before variable  (String)
  def debug(level,variable="",message=nil,truncate=nil)
    raise "Call set_debug before using debug" if !defined?(@@debug_level)
    if level<=@@debug_level
      #parse the caller array to determine who called us, what line, and what file
      caller[0]=~/(.*):(\d+):.*`(.*?)'/
     
      file_tmp=$1
      debug_line=$2
      debug_func=$3
      tmp_split=file_tmp.split("/")

      if (len=tmp_split.length)>2
        debug_file=".../#{tmp_split[len-2]}/#{tmp_split[len-1]}"
      else
        debug_file=file_tmp
      end

      strval=""
      if variable.nil?
        strval="nil"
      elsif variable.class==String
        strval=variable
        if !truncate.nil?
          if truncate<strval.length then
            o_strval=strval
            strval=o_strval[0..(truncate/2)]
            strval+= "  .....  "
            strval+=o_strval[(o_strval.length-(truncate/2))..o_strval.length]
          end
        end
      else
        strval=variable.inspect
        if !truncate.nil?
          if truncate<strval.length then
            o_strval=strval
            strval=o_strval[0..(truncate/2)]
            strval+= "  .....  "
            strval+=o_strval[(o_strval.length-(truncate/2))..o_strval.length]
          end
        end
      end

      if !message.nil?
        strval = message + ": " + strval
      end
      puts "D#{level} #{debug_file}:#{debug_func}:#{debug_line} #{strval}"
    end
  end

  # Debug_facility is a copy of the above function in an effort to shorten
  # code path.
  # facility - symbol denoting logging facility
  # level - level to show message (Integer)
  # variable - variable to show (Object)
  # message - message to be prepended before variable  (String)
  def debug_facility(facility,level,variable="",message=nil,truncate=nil)
    facility_level=@@facility_level[facility]
    raise "Call set_debug before using debug" if !defined?(@@debug_level)
    raise "Unknown facility type: #{facility.to_s}" if facility_level.nil?
    if level<=facility_level
      #parse the caller array to determine who called us, what line, and what file
      caller[0]=~/(.*):(\d+):.*`(.*?)'/
     
      file_tmp=$1
      debug_line=$2
      debug_func=$3
      tmp_split=file_tmp.split("/")

      if (len=tmp_split.length)>2
        debug_file=".../#{tmp_split[len-2]}/#{tmp_split[len-1]}"
      else
        debug_file=file_tmp
      end

      strval=""
      if variable.nil?
        strval="nil"
      elsif variable.class==String
        strval=variable
        if !truncate.nil?
          if truncate<strval.length then
            o_strval=strval
            strval=o_strval[0..(truncate/2)]
            strval+= "  .....  "
            strval+=o_strval[(o_strval.length-(truncate/2))..o_strval.length]
          end
        end
      else
        strval=variable.inspect
        if !truncate.nil?
          if truncate<strval.length then
            o_strval=strval
            strval=o_strval[0..(truncate/2)]
            strval+= "  .....  "
            strval+=o_strval[(o_strval.length-(truncate/2))..o_strval.length]
          end
        end
      end

      if !message.nil?
        strval = message + ": " + strval
      end
      puts "D#{level}(#{facility.to_s}) #{debug_file}:#{debug_func}:#{debug_line} #{strval}"
    end
  end

end  # end Debug module
