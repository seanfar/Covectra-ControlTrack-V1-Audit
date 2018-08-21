# vi: set noet:
audit.pdf: audit.md
	pandoc --standalone \
		--pdf-engine=xelatex \
		--variable urlcolor=Coral \
		--variable linkcolor=Coral \
		--number-sections \
		-o $@ $^
