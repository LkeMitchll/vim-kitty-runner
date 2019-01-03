function! s:InitVariable(var, value)
  if !exists(a:var)
    let escaped_value = substitute(a:value, "'", "''", "g")
    silent exec 'let ' . a:var . ' = ' . "'" . escaped_value . "'"
    return 1
  endif
  return 0
endfunction

function! s:SendKittyCommand(command)
  let prefixed_command = g:KittyPrefix . " " . a:command
  silent exec prefixed_command
endfunction

function! s:RunCommand()
  call inputsave()
  let s:command = input('Command to run: ')
  call inputrestore()
  let s:wholecommand = join([g:KittyRunCmd, shellescape(s:command, 1), ""])

  if exists("s:runner_open")
    call s:SendKittyCommand(s:wholecommand)
  else
    let s:runner_open = 1
    call s:SendKittyCommand(g:KittyNewWinCmd)
    call s:SendKittyCommand(s:wholecommand)
  endif
endfunction

function! s:RunLastCommand()
  if exists("s:runner_open")
    call s:SendKittyCommand(s:wholecommand)
  endif
endfunction

function! s:ClearRunner()
  if exists("s:runner_open")
    call s:SendKittyCommand(g:KittyRunCmd . " ")
  endif
endfunction

function! s:KillRunner()
  if exists("s:runner_open")
    call s:SendKittyCommand(g:KittyKillCmd)
    unlet s:runner_open
  endif
endfunction

function! s:InitializeVariables()
  let uuid = system("uuidgen|sed 's/.*/&/'")[:-2]
  call s:InitVariable("g:KittyUseMaps", 1)
  call s:InitVariable("g:KittyPort", "unix:/tmp/kitty")
  call s:InitVariable("g:KittyRunnerName", "vim-cmd_" . uuid)
  call s:InitVariable("g:KittyPrefix", "!kitty @ --to=" . g:KittyPort)
  call s:InitVariable("g:KittyWinArgs", "--keep-focus --cwd=" . $PWD)
  call s:InitVariable("g:KittyRunCmd", "send-text --match=title:" . g:KittyRunnerName)
  call s:InitVariable("g:KittyKillCmd", "close-window --match=title:" . g:KittyRunnerName)
  call s:InitVariable("g:KittyNewWinCmd", "new-window --title " . g:KittyRunnerName . " " . g:KittyWinArgs)
endfunction

function! s:DefineCommands()
  command! KittyRunCommand call s:RunCommand()
  command! KittyRunCommandAgain call s:RunLastCommand()
  command! KittyClearRunner call s:ClearRunner()
  command! KittyKillRunner call s:KillRunner()
endfunction

function! s:DefineKeymaps()
  if g:KittyUseMaps
    nmap <Leader>tr :KittyRunCommand<CR>
    nmap <Leader>tc :KittyClearRunner<CR>
    nmap <Leader>tk :KittyKillRunner<CR>
    nmap <Leader>tl :KittyRunCommandAgain<CR>
  endif
endfunction

call s:InitializeVariables()
call s:DefineCommands()
call s:DefineKeymaps()
