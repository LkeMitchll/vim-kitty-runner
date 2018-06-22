function! s:InitVariable(var, value)
  if !exists(a:var)
    let escaped_value = substitute(a:value, "'", "''", "g")
    silent exec 'let ' . a:var . ' = ' . "'" . escaped_value . "'"
    return 1
  endif
  return 0
endfunction

function! s:RunCommand()
  call inputsave()
  let s:command = input('Command to run: ')
  call inputrestore()
  if exists("s:runner_open")
    silent exec "!kitty @ --to=". g:KittyPort. " send-text --match=title:". g:KittyRunnerName. " " .s:command. ""
  else
    let s:runner_open = 1
    silent exec "!kitty @ --to=". g:KittyPort. " new-window --title ". g:KittyRunnerName. " --keep-focus --cwd=". $PWD
    silent exec "!kitty @ --to=". g:KittyPort. " send-text --match=title:". g:KittyRunnerName. " " .s:command. ""
  endif
endfunction

function! s:RunLastCommand()
  silent exec "!kitty @ --to=". g:KittyPort. " send-text --match=title:". g:KittyRunnerName. " " .s:command. ""
endfunction

function! s:ClearRunner()
  silent exec "!kitty @ --to=". g:KittyPort. " send-text --match=title: ". g:KittyRunnerName. ""

endfunction

function! s:KillRunner()
  silent exec "!kitty @ --to=". g:KittyPort. " close-window --match=title:vim-cmd"
  unlet s:runner_open
endfunction

function! s:InitializeVariables()
  call s:InitVariable("g:KittyPort", "unix:/tmp/kitty")
  call s:InitVariable("g:KittyRunnerName", "vim-cmd")
endfunction

function! s:DefineCommands()
  command! KittyRunCommand call s:RunCommand()
  command! KittyRunCommandAgain call s:RunLastCommand()
  command! KittyClearRunner call s:ClearRunner()
  command! KittyKillRunner call s:KillRunner()
endfunction

function! s:DefineKeymaps()
  nmap <Leader>tr :KittyRunCommand<CR>
  nmap <Leader>tc :KittyClearRunner<CR>
  nmap <Leader>tk :KittyKillRunner<CR>
  nmap <Leader>tl :KittyRunCommandAgain<CR>
endfunction

call s:InitializeVariables()
call s:DefineCommands()
call s:DefineKeymaps()
