let s:stash_actions = {
  \ 'ctrl-d': 'git stash drop ',
  \ 'ctrl-a': 'git stash pop ', }

function! s:get_git_root()
    let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
    return v:shell_error ? '' : root
endfunction

function! s:stash_sink(lines)
    if len(a:lines) < 2
        return
    endif

    let drop = a:lines[0] == 'ctrl-d'
    let cmd = get(s:stash_actions, a:lines[0], 'echo ')
    if drop
        for idx in range(len(a:lines) - 1, 1, -1)
            let stash = matchstr(a:lines[idx], 'stash@{[0-9]\+}')
            call system(cmd.stash)
        endfor
    else
        let stash = matchstr(a:lines[1], 'stash@{[0-9]\+}')
        call system(cmd.stash)
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
    let str = split(system('git stash push '.name), '\n')[0]
    checktime
    redraw
    echo str
endfunction

function! fuzzystash#list_stash(...)
    let root = s:get_git_root()
    if empty(root)
        return 0
    endif
    let source = 'git stash list'
    let expect_keys = join(keys(s:stash_actions), ',')
    let options = {
    \ 'source': source,
    \ 'sink*': function('s:stash_sink'),
    \ 'options': ['--ansi', '--multi', '--tiebreak=index', '--reverse',
    \   '--inline-info', '--prompt', 'Stashes> ', '--header',
    \   ':: Press CTRL-D to drop stash', '--expect='.expect_keys,
    \   '--preview', 'grep -o "stash@{[0-9]\+}" <<< {} | xargs git stash show --format=format: -p --color=always']
    \ }
    return fzf#run(fzf#wrap("Test", options, 0))
endfunction


