if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet elseif elseif ( ".st."condition".et." ) {<CR><Tab>".st.et."<CR>}<CR>".st.et
exec "Snippet do do<CR>{<CR>".st.et."<CR><CR>} while ( ".st.et." );<CR>".st.et
exec "Snippet req require_once( '".st."file".et."' );<CR>".st.et
exec "Snippet if? $".st."retVal".et." = ( ".st."condition".et." ) ? ".st."a".et." : ".st."b".et." ;<CR>".st.et
exec "Snippet phpp <?php<CR><CR>".st.et."<CR><CR>?>".st.et
exec "Snippet switch switch ( ".st."variable".et." )<CR>{<CR>case '".st."value".et."':<CR>".st.et."<CR>break;<CR><CR>".st.et."<CR><CR>default:<CR>".st.et."<CR>break;<CR>}<CR>".st.et
exec "Snippet class #doc<CR>#classname:".st."ClassName".et."<CR>#scope:".st."PUBLIC".et."<CR>#<CR>#/doc<CR><CR>class ".st."ClassName".et." ".st."extendsAnotherClass".et."<CR>{<CR>#internal variables<CR><CR>#Constructor<CR>function __construct ( ".st."argument".et.")<CR>{<CR>".st.et."<CR>}<CR>###<CR><CR>}<CR>###".st.et
exec "Snippet incll include_once( '".st."file".et."' );".st.et
exec "Snippet incl include( '".st."file".et."' );".st.et
exec "Snippet foreach foreach( $".st."variable".et."s as $".st."variable".et." ) {<CR>".st.et."<CR>}<CR>".st.et
Snippet each foreach( $<{variable}> as $<{variable:substitute(@z,'^.*\-.\|s$','','g')}> ) {<CR><{}><CR>}<CR><{}>
exec "Snippet eachthis foreach( $this->".st."variable".et."s as $".st."variable".et." ) {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet eachkey foreach( $".st."variable".et."s as $".st."key".et." => $".st."value".et." ) {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet ifelse if ( ".st."condition".et." ) {<CR>".st.et."<CR>} else {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet $_ $_REQUEST['".st."variable".et."']<CR>".st.et
exec "Snippet case case '".st."variable".et."':<CR>".st.et."<CR>break;<CR>".st.et
exec "Snippet print print \"".st."string".et."\"".st.et.";".st.et."<CR>".st.et
exec "Snippet println print \"".st."string".et."\" . ".st.et."\"<br>\\n\"".";"."<CR>".st.et
exec "Snippet function ".st."public".et."function ".st."FunctionName".et." (".st.et.") {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet func function ".st."FunctionName".et." (".st.et.") {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet priv private function ".st."FunctionName".et."( ".st.et." ) {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet prot protected function ".st."FunctionName".et."( ".st.et." ) {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet if if ( ".st."condition".et." ) {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet else else {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet array $".st."arrayName".et." = array( '".st.et."',".st.et." );".st.et
exec "Snippet -globals $GLOBALS['".st."variable".et."']".st.et.st."something".et.st.et.";<CR>".st.et
exec "Snippet reqall require( '".st."file".et."' );<CR>".st.et
exec "Snippet for for ( $".st."i".et."=".st.et."; $".st."i".et." < ".st.et."; $".st."i".et."++ ) { <CR>".st.et."<CR>}<CR>".st.et
exec "Snippet while while ( ".st.et." ) {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet html <html><CR><head><CR></head><CR><body><CR>".st.et."<CR></body><CR></html>".st.et
exec "Snippet die die( \"".st.et."\\n\" );".st.et
exec "Snippet ln \"\\n\"".st.et

exec "Snippet debug Ak::wtf(\"".st.et."\");<CR>".st.et
exec "Snippet wtf Ak::wtf(\"".st.et." -> \".print_r($".st.et.",true));<CR>".st.et
exec "Snippet glob Ak::wtf(\"*********************\");<CR>Ak::wtf(\"".st.et."\");<CR>Ak::wtf(\"********************\");<CR>".st.et
exec "Snippet globa Ak::wtf(\"".st."char".et.st."char".et.st."char".et.st."char".et.st."char".et.st."char".et.st."char".et.st."char".et.st."char".et.st."char".et."\");<CR>Ak::wtf(\"".st.et."\");<CR>Ak::wtf(\"********************\");".st.et
exec "Snippet dump Ak::dumpObject($".st.et.");<CR>".st.et
exec "Snippet dumps Ak::dumpObjects($".st.et.");<CR>".st.et
exec "Snippet stack $exceptionStackXXX = new Exception();<CR>print $exceptionStackXXX->getTraceAsString();<CR>".st.et
exec "Snippet pglob print(\"*********************\\n\");<CR>print(\"".st.et."\\n\");<CR>print(\"********************\\n\");<CR>".st.et

" Akelos snippets
exec "Snippet up function up_".st."version".et."() {<CR>".st.et."<CR>}<CR><CR>function down_".st."version".et."() {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet upcol function up_".st."version".et."() {<CR>$this->addColumn('".st."tablename".et."','".st."columnname".et."');<CR>}<CR><CR>function down_".st."version".et."() {<CR>$this->removeColumn('".st."tablename".et."','".st."columnname".et."');<CR>}<CR>".st.et
exec "Snippet addcol $this->addColumn('".st."tablename".et."','".st."columnname".et."');<CR>$this->removeColumn('".st."tablename".et."','".st."columnname".et."');<CR>".st.et
exec "Snippet test function test".st."FunctionName".et." (".st.et.") {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet r print_r(".st.et.");".st.et

" Template snippets
exec "Snippet event dojoAttachEvent='".st.et."'".st.et

" Unit/Functional test snippets
exec "Snippet testdie $this->_db->connection->CompleteTrans(true); die;".st.et
