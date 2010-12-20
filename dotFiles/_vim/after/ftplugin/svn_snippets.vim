if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet bug 750".st.et
exec "Snippet test 1059".st.et
exec "Snippet framework 1080".st.et
exec "Snippet claim 1075".st.et
exec "Snippet perf 3072".st.et
exec "Snippet billingperf 4749".st.et

Snippet review Review Id: <{}><CR>Publish: <{}><CR>Reviewers: <{}>
