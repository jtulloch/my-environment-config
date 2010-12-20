task :default  => [:install]

task :install do
  Dir.entries("dotFiles").each do |file|
    if file =~ /\A_.*/
      full_path = File.expand_path("dotFiles/#{file}")
      full_link = File.expand_path("~")
      full_link << "/#{file.gsub(/\A_/,'.')}"
      unless File.exist?(full_link) 
        puts "Adding symlink from #{full_path} to #{full_link}"
        File.symlink(full_path,full_link)
      else 
        puts "#{full_link} already exists. If you intend to replace it, please delete it before running install"
      end
    end
  end
end

