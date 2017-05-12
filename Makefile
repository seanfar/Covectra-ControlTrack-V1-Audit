# vi: set noet:
audit.pdf: audit.md
	pandoc --standalone \
		--latex-engine=xelatex \
		--variable urlcolor=Coral \
		--variable linkcolor=Coral \
		--number-sections \
		-o $@ $^
