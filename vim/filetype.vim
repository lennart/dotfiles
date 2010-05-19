au BufRead,BufNewFile /usr/local/Cellar/nginx/*/conf/* set ft=nginx 
au BufRead,BufNewFile /opt/nginx/conf/* set ft=nginx 

" markdown filetype file

if exists("did\_load\_filetypes")

  finish

endif

augroup markdown

  au! BufRead,BufNewFile *.md   setfiletype mkd
  au! BufRead,BufNewFile *.j   setfiletype objj


augroup END
runtime! ftdetect/*.vim
au BufNewFile,BufRead *.mustache        setf mustache
