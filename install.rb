#!/usr/bin/env ruby
require 'fileutils'
include FileUtils
File.class_eval do
  root_path = File::expand_path(File::dirname(__FILE__))
  files = %w{~/.vim ~/.vimrc ~/.gvimrc ~/.gitconfig}
  existing = lambda do |files| 
    files.inject(true) do |exists,current|
      exists or File::exists?(File::expand_path(current) )
    end
  end
  files_exists = existing.call files
  puts "fileS: #{files_exists}"
  unless files_exists
    ln_s File.join(root_path, ".vim"), File.expand_path("~"), :verbose => true
    rm File.expand_path(".vim-extras"), :verbose => true
    ln_s File.join(root_path, ".vim-extras"), File.expand_path("~"), :verbose => true
    suffix = "mac"
    if (/^Linux/.match(`uname` ) )
      suffix = "linux"
    end
    ln_s File.join(root_path, ".vimrc"), File.expand_path("~/.vimrc"), :verbose => true
    ln_s File.join(root_path, ".gvimrc-#{suffix}"), File.expand_path("~/.gvimrc"), :verbose =>true
    ln_s File.join(root_path, ".gitconfig"), File.expand_path("~/.gitconfig"), :verbose =>true
  else
    puts "Cannot proceed Files exists: \n #{files.join("\n")}"
  end
end
