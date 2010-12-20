if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet proto ".st."className".et.".prototype.".st."methodName".et." = function(".st.et.")<CR>{<CR>".st.et."<CR>};<CR>".st.et
exec "Snippet fun function ".st."functionName".et." (".st.et.")<CR>{<CR><Tab>".st.et."<CR><BS>}<CR>".st.et
exec "Snippet curveReq dojo.require('curve.".st.et."');<CR>".st.et
exec "Snippet dijitReq dojo.require('dijit.".st.et."');<CR>".st.et
exec "Snippet dojoReq dojo.require('dojo.".st.et."');<CR>".st.et
exec "Snippet dojoxReq dojo.require('dojox.".st.et."');<CR>".st.et
exec "Snippet debug console.debug('".st.et."');".st.et
exec "Snippet wtf console.debug('".st.et."', ".st.et.");<CR>".st.et
exec "Snippet dir console.dir(".st.et.");<CR>".st.et
exec "Snippet mix postMixInProperties: function() {<CR>this.inherited(arguments);<CR>".st.et."<CR>},<CR>".st.et
exec "Snippet create postCreate: function() {<CR>this.inherited(arguments);<CR>".st.et."<CR>},<CR>".st.et
exec "Snippet func ".st."functionName".et.": function(".st.et.") {<CR>".st.et."<CR>},<CR>".st.et
exec "Snippet get _get".st."attrname".et."Attr: function() {<CR>".st.et."<CR>},<CR>".st.et
exec "Snippet set _set".st."attrname".et."Attr: function(value) {<CR>".st.et."<CR>},<CR>".st.et
exec "Snippet each forEach(<CR><TAB>function(".st.et.") {<CR>".st.et."<CR>},<CR>this<CR><BS>);".st.et
exec "Snippet eachs ".st."item".et."s.forEach(<CR><TAB>function(".st."item".et.") {<CR>".st.et."<CR>},<CR>this<CR><BS>);".st.et
