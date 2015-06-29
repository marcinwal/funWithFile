module File_helper

  def load_file(path,rules)

    result = {}
    if !File.exist?(path)
      puts "Wrong input.Source file does not exist"
      exit 0
    end
    File.open(path, "r").each_line do |line|
      for title,pattern in rules do 
        result[title] ||= []
        match_result = pattern.match(line)
        if  match_result
          result[title] << match_result[0]
          break
        end
      end
    end
    result
  end
  
  def save_file(path,array)
    File.open(path,'w') do |f|
      array.each do |el| 
        f.write(el)
        f.write(' ')
      end
    end
  end


end