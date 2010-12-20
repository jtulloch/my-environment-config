au BufNewFile ~/scripts/*.php     call LoadTemplate( '/home/shared/templates/scripts.php' )
au BufNewFile *.php     call LoadTemplate( '/home/shared/templates/template.php' )
au BufNewFile *.sh     call LoadTemplate( '/home/shared/templates/template.sh' )
au BufNewFile *.email     call LoadTemplate( '/home/shared/templates/template.email' )

