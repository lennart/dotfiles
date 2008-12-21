#!/usr/bin/env ruby
require 'fileutils'
include FileUtils




File.class_eval do
  root_path = expand_path(dirname(__FILE__))
  files = %w{~/.vim ~/.vimrc ~/.gvimrc ~/.gitconfig}
  existing = lambda do |files| 
    files.inject(false) do |exists,current|
      exists or exists?(expand_path(current) )
    end
  end
  files_exists = existing.call files
  puts "fileS: #{files_exists}"
  unless files_exists
    ln_s join(root_path, ".vim"), expand_path("~"), :verbose => true
    rm expand_path(".vim-extras"), :verbose => true
    ln_s join(root_path, ".vim-extras"), expand_path("~"), :verbose => true
    suffix = "mac"
    if (/^Linux/.match(`uname` ) )
      suffix = "linux"
    end
    ln_s join(root_path, ".vimrc"), expand_path("~/.vimrc"), :verbose => true
    ln_s join(root_path, ".gvimrc-#{suffix}"), expand_path("~/.gvimrc"), :verbose =>true
    ln_s join(root_path, ".gitconfig"), expand_path("~/.gitconfig"), :verbose =>true
  else
    puts "Cannot proceed Files exists: \n #{files.join("\n")}"
  end
end
