require 'rake'
require 'fileutils'
require 'erb'

desc "install the dot files into user's home directory"
task :install do
  replace_all = false
  Dir['*'].each do |file|
    next if %w[Rakefile README.rdoc LICENSE vim-extras nerdtree].include? file
    
    if File.exist?(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"))
      if File.identical? file, File.join(ENV['HOME'], ".#{file.sub('.erb', '')}")
        puts "identical ~/.#{file.sub('.erb', '')}"
      elsif replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file.sub('.erb', '')}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file.sub('.erb', '')}"
        end
      end
    else
      link_file(file)
    end
  end
end

def replace_file(file)
  FileUtils.rm_rf File.join(ENV["HOME"],".#{file.sub('.erb','')}"), :verbose => true
  link_file(file)
end

def link_file(file)
  if file =~ /.erb$/
    puts "generating ~/.#{file.sub('.erb', '')}"
    platform = `uname`.strip
    File.open(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"), 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking ~/.#{file}"
    system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
  end
end

# written by travis jeffery <travisjeffery@gmail.com>
# contributions by scrooloose <github:scrooloose>

require 'rake'
require 'find'
require 'pathname'

IGNORE = [/\.gitignore$/, /Rakefile$/]

files = `cd nerdtree && git ls-files`.split("\n")
files.reject! { |f| IGNORE.any? { |re| f.match(re) } }


namespace :nerdtree do
  desc 'Install plugin and documentation'
  task :install do
    vimfiles = if ENV['VIMFILES']
                 ENV['VIMFILES']
               elsif RUBY_PLATFORM =~ /(win|w)32$/
                 File.expand_path("~/vimfiles")
               else
                 File.expand_path("~/.vim")
               end
    files.each do |file|
      target_file = File.join(vimfiles, file)
      FileUtils.mkdir_p File.dirname(target_file)
      Dir.chdir("nerdtree") do
        FileUtils.cp file, target_file
      end
      puts "Installed #{file} to #{target_file}"
    end

  end

  desc 'Pulls from origin'
  task :pull do
    puts "Updating local repo..."
    puts `git submodule update`
  end

  desc 'Calls pull task and then install task'
  task :update => ['pull', 'install'] do
    puts "Update of vim script complete."
  end

  desc 'Uninstall plugin and documentation'
  task :uninstall do
    vimfiles = if ENV['VIMFILES']
                 ENV['VIMFILES']
               elsif RUBY_PLATFORM =~ /(win|w)32$/
                 File.expand_path("~/vimfiles")
               else
                 File.expand_path("~/.vim")
               end
    files.each do |file|
      target_file = File.join(vimfiles, file)
      FileUtils.rm target_file

      puts "Uninstalled #{target_file}"
    end

  end

  task :default => ['update']
end

task :default => [:install, :"nerdtree:default"]
