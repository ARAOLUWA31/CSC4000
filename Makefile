#
# Main Makefile for latex/slides (gnu make only, sorry)
#
# Fri Mar 23, 2001 version
#


# TEXINPUTS - where latex looks for stuff
TEXINPUTS_IRG=/home/sdo/lib/latex:/Users/sdo/lib/latex
TEXINPUTS_CS=/usr/local/lib/texmf/tex/latex2e/base/:/home/osterman/lib/latex
export TEXINPUTS=.:${TEXINPUTS_IRG}:${TEXINPUTS_CS}:

#   (Modify PATH to include ostermann's directory, for missing stuff)
PATH_IRG=/home/sdo/bin
PATH_CS=/home/osterman/bin
export PATH+=${PATH_CS}:${PATH_IRG}


# disable automatic RCS
%: RCS/%,v
%: %,v


#
# Magic suffixes
#
.SUFFIXES:	.tex .dvi .sm .ps .pdf .eps .4up .8up .16up .64up .128up .pic .fig .cm .text .cites .jpg .gif .dia


#
# tools
#
FIG2TEX	=	fig2ps2tex
FIG2PS	=	fig2ps
DVI2PS	=	dvips -t landscape
DVI2PS	=	dvips
DVI2TEXT=	dvitty -w132
CMAKER	=	cmaker -s 0.60
4UP	=	4up
8UP	=	8up
16UP	=	16up
64UP	=	64up
128UP	=	128up
SMAKER	=	smaker
END=

# How to run latex
LATEX = latex <&-


#
# default rules
#
.tex.dvi:
	${LATEX} $*


#
# turn a .dvi file into PS
#
.dvi.ps:
	${DVI2PS} -o .$*.ps $*.dvi && /bin/mv .$*.ps $*.ps

#
# turn a .dvi file into text
#
.dvi.text:
	${DVI2TEXT} $*.dvi > $*.text

#
# turn a .ps file into '4 up' format
#
%.4up.ps: %.ps Makefile
	${4UP} $*.ps > $*.4up.ps

#
# turn a .ps file into '8 up' format
#
%.8up.ps: %.ps
	${8UP} $*.ps > $*.8up.ps

#
# turn a .ps file into Doug's '16 up' format
#
%.16up.ps: %.ps
	${16UP} $*.ps > $*.16up.ps
	ps5per $*.16up.ps



#
# turn a .fig file into latex input format
#
.fig.tex: ;
	${FIG2PS} $*.fig > $*.ps &&		\
	${FIG2TEX} $*.ps ${DIRNAME} > .$*.tex &&	\
	/bin/mv .$*.tex $*.tex
#
# turn a .jpg file into an EPS file
#
${JPGFILES}: ${JPGSOURCES}
.jpg.eps: ;
	djpeg -colors 256 -pnm $*.jpg | pnmtops > $*.eps

#
# turn a .gif file into an EPS file
#
.gif.eps: ;
	giftoppm $*.gif | ppmtopgm | pnmscale 0.45 | pnmtops > $*.eps

#
# turn a .eps file into latex input format
#
.eps.tex: ;
	${FIG2TEX} $*.eps ${DIRNAME} > .$*.tex &&	\
	/bin/mv .$*.tex $*.tex
#
# turn a .pic file into tex
#
.pic.tex: ;
	tpic $*
#
# turn a Postscript file into an Adobe PDF format file
#
%.pdf: %.ps
	ps2pdf $*.ps $*.pdf
#
# turn a .cm file into latex input format and postscript
#
.cm.tex: ;
	${CMAKER} $*.cm > $*.ps &&			\
	${FIG2TEX} $*.ps ${DIRNAME} > .$*.tex &&	\
	/bin/mv .$*.tex $*.tex

#
# turn a "dia" .dia file into postscript
#
.dia.eps: ;
	dia -e .$*.eps $*.dia && \
	/bin/mv .$*.eps $*.eps

#
# turn a .tex file into ASCII citations
#
.ps.cites: ;
	ps2ascii $*.ps | awk ' \
	/BIBLIOGRAPHY/ {doit=1} \
	{if (doit) print} \
	' | nroff | uniq > $*.cites



TEXSOURCES=${filter-out fig_%.tex,${wildcard *.tex}}
FIGSOURCES=${wildcard fig_*.fig}
PICSOURCES=${wildcard fig_*.pic}
EPSSOURCES=${wildcard fig_*.eps}
CMSOURCES=${wildcard  fig_*.cm}
JPGSOURCES=${wildcard  fig_*.jpg}
GIFSOURCES=${wildcard  fig_*.gif}
DIASOURCES=${wildcard  fig_*.dia}
STYFILES=${wildcard  *.sty}
FIGFILES=${FIGSOURCES:.fig=.tex}
JPGFILES=${JPGSOURCES:.jpg=.eps}
GIFFILES=${GIFSOURCES:.gif=.eps}
PICFILES=${PICSOURCES:.pic=.tex}
EPSFILES=${EPSSOURCES:.eps=.tex}
CMFILES=${CMSOURCES:.cm=.tex}
DIAFILES=${DIASOURCES:.dia=.eps}
DEPFILES=${FIGFILES} ${PICFILES} ${CMFILES} ${STYFILES} ${GIFFILES} ${JPGFILES} ${DIAFILES}
DVIFILES=${TEXSOURCES:.tex=.dvi}
TEXTFILES=${DVIFILES:.dvi=.text}
PSFILES=${TEXSOURCES:.tex=.ps}
CITEFILES=${PSFILES:.ps=.cites}
PDFFILES=${TEXSOURCES:.tex=.pdf}
PS4FILES=${TEXSOURCES:.tex=.4up}




############################################################
#
# Master rule: just run latex over all the latex files
#
############################################################
.PHONY: default
default: ${DVIFILES} ps maybepdf


############################################################
#
# Optional rule: generate PS files from dvi files
#
############################################################
.PHONY: ps
ps: ${PSFILES}


############################################################
#
# Optional rule: run bibtex, make a local bibfile
#
############################################################
bib:
	bibtex foo
	bibgen



############################################################
#
# Optional rule: generate PDF files from PS files
# pdf files are always updated, but not CREATED by default
#
############################################################
.PHONY: pdf maybepdf
EXISTING_PDF_FILES=${wildcard *.pdf}
maybepdf: ${EXISTING_PDF_FILES}
pdf: ${PDFFILES}


############################################################
#
# Optional rule: suck citations into text
#
############################################################
text_cites: ${PSFILES}
	@echo "Citations:"
	@ps2ascii *.ps |	awk ' \
	/References/ {doit=1;} \
	{if (doit) print} \
	'  | uniq



############################################################
#
# Dependencies, EVERYTHING depends on the figures
#
############################################################
${DVIFILES}: ${DEPFILES}




CLEANFILES=			\
	styl.tmp		\
	.*_slides.tex		\
	fig_*.ps		\
	fig_*.tex		\
	${PSFILES}		\
	${PDFFILES}		\
	*.*[0-9]up		\
	${END}

clean:
	rm -f ${CLEANFILES}; texclean -all


.PHONY: vartest
vartest:
	@echo
	@echo "PATH: " ${PATH}
	@echo
	@echo "TEXINPUTS: " ${TEXINPUTS}
	@echo
	@echo "printenv PATH: " ; printenv PATH
