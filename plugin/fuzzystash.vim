command! -nargs=? GStash     call fuzzystash#create_stash(<q-args>)
command!          GStashList call fuzzystash#list_stash(<q-args>)

