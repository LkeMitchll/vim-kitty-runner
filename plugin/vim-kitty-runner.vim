function! s:InitVariable(var, value)
  if !exists(a:var)
    let escaped_value = substitute(a:value, "'", "''", "g")
    silent exec 'let ' . a:var . ' = ' . "'" . escaped_value . "'"
    return 1
  endif
  return 0
endfunction

function! s:SendKittyCommand(command)
  let prefixed_command = "!kitty @ --to=" . g:KittyPort . " " . a:command
  silent exec prefixed_command
endfunction

function! s:SwitchKittyLayout()
  if g:KittySwitchFocus
    let layout_command = "!kitty @ goto-layout " . g:KittyFocusLayout
    silent exec layout_command
  endif
endfunction

function! s:SpawnRunner()
  if exists("s:runner_open")
    echo("Runner already exists")
  else
    let s:runner_open = 1
    call s:SendKittyCommand("new-window --title " . s:runner_name . " " . g:KittyWinArgs)
    call s:SwitchKittyLayout()
  endif
endfunction

function! s:RunCommand()
  call inputsave()
  let s:command = input('Command to run: ')
  call inputrestore()
  let s:wholecommand = join([s:run_cmd, shellescape(s:command, 1), shellescape('\n')])

  if exists("s:runner_open")
    call s:ClearRunner()
    call s:SendKittyCommand(s:wholecommand)
    call s:SwitchKittyLayout()
  else
    let s:runner_open = 1
    call s:SendKittyCommand("new-window --title " . s:runner_name . " " . g:KittyWinArgs)
    call s:SendKittyCommand(s:wholecommand)
    call s:SwitchKittyLayout()
  endif
endfunction

function! s:RunLastCommand()
  if exists("s:runner_open")
    call s:ClearRunner()
    call s:SendKittyCommand(s:wholecommand)
    call s:SwitchKittyLayout()
  endif
endfunction

function! s:ClearRunner()
  if exists("s:runner_open")
    call s:SendKittyCommand(join([s:run_cmd, shellescape("clear", 1), shellescape('\n')]))
    call s:SendKittyCommand("scroll-window --match=title:" . s:runner_name . " end")
  endif
endfunction

function! s:KillRunner()
  if exists("s:runner_open")
    call s:SendKittyCommand(s:kill_cmd)
    unlet s:runner_open
  endif
endfunction

function! s:InitializeVariables()
  let uuid = system("uuidgen|sed 's/.*/&/'")[:-2]
  let s:runner_name = "vkr_" . uuid
  let s:run_cmd = "send-text --match=title:" . s:runner_name
  let s:kill_cmd = "close-window --match=title:" . s:runner_name
  call s:InitVariable("g:KittyUseMaps", 1)
  call s:InitVariable("g:KittyPort", "unix:/tmp/kitty")
  call s:InitVariable("g:KittyWinArgs", "--keep-focus --cwd=" . $PWD)
  call s:InitVariable("g:KittySwitchFocus", 0)
  call s:InitVariable("g:KittyFocusLayout", "fat:bias=70")
  call s:InitVariable("g:KittyKillOnQuit", 1)
endfunction

function! s:DefineCommands()
  command! KittySpawnRunner call s:SpawnRunner()
  command! KittyRunCommand call s:RunCommand()
  command! KittyRunCommandAgain call s:RunLastCommand()
  command! KittyClearRunner call s:ClearRunner()
  command! KittyKillRunner call s:KillRunner()
endfunction

function! s:DefineKeymaps()
  if g:KittyUseMaps
    nmap <Leader>ts :KittySpawnRunner<CR>
    nmap <Leader>tr :KittyRunCommand<CR>
    nmap <Leader>tc :KittyClearRunner<CR>
    nmap <Leader>tk :KittyKillRunner<CR>
    nmap <Leader>tl :KittyRunCommandAgain<CR>
  endif
endfunction

call s:InitializeVariables()
call s:DefineCommands()
call s:DefineKeymaps()

if g:KittyKillOnQuit
  autocmd ExitPre * :KittyKillRunner
endif
