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
  let s:wholecommand = join([g:KittyRunCmdPrefix, shellescape(s:command, 1), ""])

  if exists("s:runner_open")
    silent exec s:wholecommand
  else
    let s:runner_open = 1
    silent exec g:KittyNewWinCmdPrefix
    silent exec s:wholecommand
  endif
endfunction

function! s:RunLastCommand()
  silent exec s:wholecommand
endfunction

function! s:ClearRunner()
  silent exec g:KittyPrefix . " send-text --match=title:" . g:KittyRunnerName . " "
endfunction

function! s:KillRunner()
  if exists("s:runner_open")
    silent exec g:KittyPrefix . " close-window --match=title:" . g:KittyRunnerName
    unlet s:runner_open
  endif
endfunction

function! s:InitializeVariables()
  let uuid = system("uuidgen|sed 's/.*/&/'")[:-2]
  call s:InitVariable("g:KittyPort", "unix:/tmp/kitty")
  call s:InitVariable("g:KittyRunnerName", join(["'vim-cmd_", uuid, "'"], ""))
  call s:InitVariable("g:KittyPrefix", join(["!kitty @ --to=", g:KittyPort], ""))
  call s:InitVariable("g:KittyRunCmdPrefix", join([g:KittyPrefix, join(["send-text --match=title:", g:KittyRunnerName], "")]))
  call s:InitVariable("g:KittyNewWinCmdPrefix", join([g:KittyPrefix, join([" new-window --title ", g:KittyRunnerName], ""), join(["--keep-focus --cwd=", $PWD], "")]))
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
