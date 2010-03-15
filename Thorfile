module Dotfiles 
  class AutoInstaller < Thor::Group
    desc "Installs all dotfiles to HOME and Thorfiles system-wide"
    include Thor::Actions
    add_runtime_options!
    class_options %w(skiperb -e) => false

    def setup
      @installer = Installer.new options
    end

    def files
      excludes = %w{. .. README.md Rakefile Thorfile LICENSE}
      include_dirs = %w{bash vim}
      files_to_install = Dir["*"].reject do |f|
        if options[:skiperb] and f =~ %r{\.erb$}
          true
        else
          (File.directory?(f) and not include_dirs.include?(f)) or excludes.include?(f)
        end
      end
      say "Installing: #{files_to_install.join(", ")}" unless options[:quiet]
      @installer.file *files_to_install
    end

    def thorfiles
      tfiles = Dir["thor/*.thor"]
      erbfiles = Dir["thor/*.erb"]
      tfiles.reject! {|f| erbfiles.include?("#{f}.erb") }
      unless options[:skiperb]
        @installer.thorfile *erbfiles
      end
      @installer.thorfile *tfiles
    end
  end

  class Io < Thor::Group
    desc "Sets up io_credentials and io.thor"
    include Thor::Actions

    def setup
      @installer = Installer.new options
    end

    def credentials
      @installer.file("io_credentials")
    end

    def io
      @installer.thorfile "io"
    end
      
  end

  class Installer < Thor
    map "-i" => :file
    map "-t" => :thorfile
    map "-a" => :auto
    map "-s" => :auto_skip_erb
    include Thor::Actions
    add_runtime_options!


    desc "auto", "Runs AutoInstaller"
    def auto
      AutoInstaller.new.invoke
    end

    desc "auto_skip_erb", "Runs AutoInstaller with skip_erb option"
    def auto_skip_erb
      AutoInstaller.new([],:skiperb => true).invoke
    end

    desc "thorfile THORFILE", "Installs given .thor file[s] system-wide"
    def thorfile *args
      if args.kind_of? Array
        args.each do |f|
          one_thorfile f
        end
      else
        one_thorfile args
      end
    end

    desc "file FILE", "Installs the given FILE[s] to ~/.FILE, renders erb if present"
    def file *args
      if args.kind_of? Array
        args.each do |f|
          if File.directory?(f)
            dir f
          else
            one_file f
          end
        end
      else
        one_file args
      end
    end


    class << self
      def source_root
        File.dirname(__FILE__)
      end
    end

    private

    def one_thorfile name
      thorfile = "thor/#{clean_name(name).sub(%r{^thor/},"").sub(%r{.thor$},"")}.thor"
      if erb? thorfile
        template(erb_name(thorfile),thorfile)
      end
      system "thor install #{thorfile}"
    end

    def dir name, destination = File.join(File.expand_path("~"),".#{name}")
      directory name, destination
    end

    def one_file name
      clean_name = clean_name name
      destination_root = File.expand_path("~")
      output_file = File.join(destination_root, ".#{clean_name}")
      say "#{"Not really " if options[:pretend] }Installing #{clean_name} to #{output_file}"
      if erb? clean_name
        output = template(erb_name(name),output_file)
      else
        copy_file clean_name, output_file
      end
    end

    def clean_name name
      name.sub ".erb", ""
    end

    def erb_name name
      "#{clean_name name}.erb"
    end

    def erb? name
      File.exists? erb_name(name)
    end
  end

end

# vim:filetype=ruby
