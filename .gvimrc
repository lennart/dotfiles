set guifont=Monaco:h18
set vb t_vb=

let fustate=0
set fuoptions=maxhorz,maxvert
set transparency=5
set guitablabel=%t
set columns=100
set lines=35
func ToggleFullscreen()
  if fustate == 0
    let fustate=1
    set fullscreen
  else
    let fustate=0
    set nofullscreen
  endif
  return ''
endfunction
map <expr> <D-F> ToggleFullscreen() 
