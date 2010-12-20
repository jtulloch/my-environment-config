function LoadTemplate(templateFile)
	let numberOfLines = line("$")
	if numberOfLines > 1
		return
	endif

	let lines = readfile(a:templateFile)
	call append(0, lines)
	norm! zR
	norm! Gdd
	execute "normal! ?CURSOR\<CR>"
	norm! dw
endfunction
