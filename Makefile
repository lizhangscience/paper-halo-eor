ID:=		halo-eor

# EPS figures
EPS_FIG:=	$(wildcard figures/*.eps)
PDF_FIG:=	$(EPS_FIG:.eps=.pdf)

# Files to pack for AAS submission
SRCS:=		main.tex references.bib
FIGURES:=	$(wildcard figures/*.pdf)
TEMPLATE:=	aastex/aastex62.cls aastex/aasjournal-links.bst

TEXINPUTS:=	.:aastex:revtex:texmf:$(TEXINPUTS)
BSTINPUTS:=	.:aastex:revtex:texmf:$(BSTINPUTS)

DATE:=		$(shell date +'%Y%m%d')

default: main.pdf

eps2pdf: $(PDF_FIG)

report: main.pdf $(SRCS)
	@test -d "reports" || mkdir reports
	cp main.pdf reports/$(ID)-$(DATE).pdf
	cp main.tex reports/$(ID)-$(DATE).tex

main.pdf: $(SRCS) $(TEMPLATE) $(FIGURES) eps2pdf
	env TEXINPUTS=$(TEXINPUTS) BSTINPUTS=$(BSTINPUTS) latexmk -xelatex $<

aaspack: $(SRCS) $(TEMPLATE) $(FIGURES)
	mkdir $@.$(DATE)
	@for f in $(SRCS) $(TEMPLATE) $(FIGURES); do \
		cp -v $$f $@.$(DATE)/; \
	done
	tar -cf $@.$(DATE).tar -C $@.$(DATE)/ .
	rm -r $@.$(DATE)

%.pdf: %.eps
	epstopdf $^ $@

clean:
	latexmk -c main.tex
	touch main.tex

cleanall:
	latexmk -C main.tex

help:
	@echo "default - compile the paper PDF file (main.pdf)"
	@echo "eps2pdf - convert figures from EPS to PDF"
	@echo "aaspack - pack the necessary files and figures for AAS submission"
	@echo "clean - clean the temporary files"
	@echo "cleanall - clean temporary files and the output PDF file"

.PHONY: report clean cleanall help


# One liner to get the value of any makefile variable
# Credit: http://blog.jgc.org/2015/04/the-one-line-you-should-add-to-every.html
print-%: ; @echo $*=$($*)
