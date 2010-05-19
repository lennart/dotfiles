require 'couchrest'

class Did < Thor
  class Medium < CouchRest::ExtendedDocument
    use_database (@@db ||= CouchRest.new("localhost").database!("etunes"))
    def self.db
      @@db
    end
  end
  desc "mplayer UUID", "runs the mplayer on default source attached to the metadata of this UUID"
  def mplayer uuid
    unless `which mplayer`.strip.empty?
    @uuid = uuid
    if default_video
      puts "Found media file"
      puts `mplayer '#{path}'`
    else
      puts "No File attached to metadata, sry :("
      puts "Would you like to add a file and metadata? (y/N)"
      if STDIN.gets.chomp.upcase == "Y"
        puts "Would you like to add one of these?"
        files = Dir["#{uuid}.*"]
        choices = files.length
        for choice in 1..choices
          file = files[choice - 1]
          puts "[#{choice}] #{file}"
        end
        while ((taken = STDIN.gets.chomp.to_i) < 1) || (taken > choices)
          puts "Invalid Choice, please choose one of the files (CTRL+C to quit)"
        end
        taken -= 1
        puts "You chose [#{files[taken]}]"
#        doc.put_attachment("video/default#{File}
        #medium = 
      else
        puts "ok, work's done!"
      end
    end
    else 
      puts "No mplayer install, you might want to `brew install mplayer`"
    end
  end

  desc "List videos DIR", "Lists alls Video files in the current directory or in DIR"
  def videos dir = "."
    puts ""
    Dir[*%w{mp4 flv mov mpeg mpg avi ogv}.map{|f| "*.#{f}"}].each_with_index do |value, idx|
      basename = File.basename(value,File.extname(value))
      if basename =~ /(\A[0-9a-fA-F]{32}\Z)/
        uuid = $1
        begin
          existing_doc = db.get uuid
          puts "[#{idx}] #{value} - in DB"
        rescue RestClient::ResourceNotFound => e
          puts "[#{idx}] #{value} - UUID"
        end
      else
        puts "[#{idx}] #{value}"
      end
    end
  end

  private

  def default_video
    @default_video_path ||= "video/default.mp4" 

    if doc && doc.has_attachment?(@default_video_path)
      doc.attachment_url @default_video_path
    else
      false
    end
  end

  def path to = default_video
    @path = "http://" + to
  end

  def doc
    @doc = Medium.get(@uuid) || Medium.create!(:_id => @uuid)
  end

  def db
    @db = Medium.database
  end
end
