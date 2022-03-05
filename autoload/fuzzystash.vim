let s:actions = {
  \ 'pop': 'stash pop ',
  \ 'drop': 'stash drop ',
  \ 'apply': 'stash apply ', }

let s:stash_actions = get(g:, 'fuzzy_stash_actions', { 'ctrl-d': 'drop', 'ctrl-a': 'pop', 'ctrl-p': 'apply' })

function! s:get_git_root()
    let root = systemlist(FugitiveShellCommand() . ' rev-parse --show-toplevel')[0]
    return v:shell_error ? '' : root
endfunction

function! s:stash_sink(lines)
    if len(a:lines) < 2
        return
    endif

    let action = get(s:stash_actions, a:lines[0])
    let cmd = get(s:actions, action, 'echo ')
    if cmd == s:actions.drop
        for idx in range(len(a:lines) - 1, 1, -1)
            let stash = matchstr(a:lines[idx], 'stash@{[0-9]\+}')
            call system(FugitiveShellCommand() . ' ' . cmd . stash)
        endfor
    else
        let stash = matchstr(a:lines[1], 'stash@{[0-9]\+}')
        call system(FugitiveShellCommand() . ' ' . cmd . stash)
        checktime
    endif
endfunction

function! fuzzystash#create_stash(...)
    let root = s:get_git_root()
    if empty(root)
        return 0
    endif
    if len(a:000) > 0
        let name = '-m "'.a:1.'"'
    else
        let name = '' 
    endif
    let str = systemlist(FugitiveShellCommand() . ' stash push ' . name)[0]
    checktime
    redraw
    echo str
endfunction

function! fuzzystash#list_stash(...)
    let root = s:get_git_root()
    if empty(root)
        return 0
    endif
    let source = FugitiveShellCommand() . ' stash list'
    let expect_keys = join(keys(s:stash_actions), ',')
    let actions = s:translate_actions(s:stash_actions)
    let options = {
    \ 'source': source,
    \ 'sink*': function('s:stash_sink'),
    \ 'options': ['--ansi', '--multi', '--tiebreak=index', '--reverse',
    \   '--inline-info', '--prompt', 'Stashes> ', '--header',
    \   ':: ' . actions, '--expect='.expect_keys,
    \   '--preview', 'grep -o "stash@{[0-9]\+}" <<< {} | xargs ' . FugitiveShellCommand() . ' stash show --format=format: -p --color=always']
    \ }
    return fzf#run(fzf#wrap("Test", options, 0))
endfunction

function! s:translate_actions(action_dict)
    return join(map(items(a:action_dict), 'toupper(v:val[0]) . " to " . v:val[1]'), ', ')
endfunction


